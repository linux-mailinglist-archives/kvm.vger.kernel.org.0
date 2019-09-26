Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8391CBF409
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 15:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfIZN0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 09:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfIZN0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 09:26:31 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E293FC05E740
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 13:26:30 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id g65so2329425qkf.19
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 06:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W3FZ5vxqz4dbTcE/RzDr2BQP/Lbs5fzn9d+anVsPrI4=;
        b=L+7C1Uc7Jz5fehBn0vhIvDat//+wX78NaijEvcJlj/oVvR86xv7tRYpQLY5nnzhov+
         9z3D62cRGykRD7Ln4Qz2sETZb/u6xy+UXoIlD0VudVQVoCLebSSlBxI0P5lmYVeniugs
         S9omiSCkL6/SUZkYDjEB9JPaNdnNl/mqnz6sYrWGGqvZimOlU9JBPPfuGNh318s5llEW
         p/fWsS3zNCzqEAvyumkXFg2F4Qd87sZTgbyjjWKlI5463E05e8mmz5/A6Zd9wkkAo1Ue
         nMCkmY/wTleF+AyDq8dtO3BjSBTmvM8BsKPy9Nxal9mzrdnPJmND1v31AvpXahDkvz8+
         RhDA==
X-Gm-Message-State: APjAAAX7vNyDWHEAJuD/PFKyeSefqyTqJ3Vu4fluIICvDlh9HyMnbW5p
        5ncTOEWNIOPxXu53QIlFcvgzdUUF5kinfThNYguyG5N8hr3qiugOwRiMBf5HFhatssYU8L8dYBz
        +85p4O+BAIZg1
X-Received: by 2002:a05:620a:12b6:: with SMTP id x22mr3187489qki.495.1569504390225;
        Thu, 26 Sep 2019 06:26:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOqinr5Q60U60VCr+5JVsP4K+bDRuObBU2H89+wefW4qdAMViXRd1NNdEtJnFrqVLkASlPsw==
X-Received: by 2002:a05:620a:12b6:: with SMTP id x22mr3187461qki.495.1569504389940;
        Thu, 26 Sep 2019 06:26:29 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id c12sm968131qkc.81.2019.09.26.06.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 06:26:28 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:26:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com,
        maxime.coquelin@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        lingshan.zhu@intel.com
Subject: Re: [PATCH] vhost: introduce mdev based hardware backend
Message-ID: <20190926091945-mutt-send-email-mst@kernel.org>
References: <20190926045427.4973-1-tiwei.bie@intel.com>
 <20190926042156-mutt-send-email-mst@kernel.org>
 <20190926131439.GA11652@___>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926131439.GA11652@___>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 26, 2019 at 09:14:39PM +0800, Tiwei Bie wrote:
> > 4. Does device need to limit max ring size?
> > 5. Does device need to limit max number of queues?
> 
> I think so. It's helpful to have ioctls to report the max
> ring size and max number of queues.

Also, let's not repeat the vhost net mistakes, let's lock
everything to the order required by the virtio spec,
checking status bits at each step.
E.g.:
	set backend features
	set features
	detect and program vqs
	enable vqs
	enable driver

and check status at each step to force the correct order.
e.g. don't allow enabling vqs after driver ok, etc

-- 
MST
