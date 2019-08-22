Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1F699061
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 12:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbfHVKIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 06:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55688 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731425AbfHVKIj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 06:08:39 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF8EF6412E
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 10:08:39 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id l16so2749657wmg.2
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 03:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+QZ6pW149hcLIfsZZS+dKkZglSU+Xi8vHC91tSDHm3c=;
        b=I4YIAjGUZ5wtgtwWQx0fUfed5fETFcrQ5VCZKoEbh2qPNwzlhT4J8jr4KKl50xqe7c
         EpN88o4gbIEQr9h4HFaiyCGS9hkzIaV4Ww1UZ4Py88Jref7yYIi+EFXGi7q6XChFzsQP
         Tlcy8VAvlWlKdBz91ajvAfcxpzd66wLJ0sIJRvYnDbwa4aXkGKhQ49jRy11JBuCp7NCc
         Cy4IwYsyf7BUILz6vC5ezttnTSZ29n/2TXMznAsauMVMriQ++gXFeNjnMw+FNsrz3eTC
         DsrHUmN2wes1+24YDNSueprNP499LkAwITwUt0NYrXMZ1y5IzCTBZ0ZUnvQ3eamSSno8
         sSgg==
X-Gm-Message-State: APjAAAV2gAvh2uFPx6glf4QJgPUVh3V4oVoLq0vYJg6urbCRGu2Qkzdw
        2DPS54WzOpPreDqJMz1SF012wwZfosQF66NNOYupuFSXuyMkuDLJyChkljGUiYGcSS32g3qdzoj
        RhIBmXHQrgBsV
X-Received: by 2002:a1c:7513:: with SMTP id o19mr5210667wmc.126.1566468518263;
        Thu, 22 Aug 2019 03:08:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx0XnwkglmAIZNRemEqCnbp6/DI7ya5vpk8WBx5UrfbHbyKJgBnEIawFQuaHzBUlbkohxgoxQ==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr5210642wmc.126.1566468518041;
        Thu, 22 Aug 2019 03:08:38 -0700 (PDT)
Received: from steredhat (host80-221-dynamic.18-79-r.retail.telecomitalia.it. [79.18.221.80])
        by smtp.gmail.com with ESMTPSA id o129sm7596453wmb.41.2019.08.22.03.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 03:08:37 -0700 (PDT)
Date:   Thu, 22 Aug 2019 12:08:35 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/11] vsock_test: skip read() in test_stream*close
 tests on a VMCI host
Message-ID: <20190822100835.7u27ijlaydk72orv@steredhat>
References: <20190801152541.245833-1-sgarzare@redhat.com>
 <20190801152541.245833-11-sgarzare@redhat.com>
 <20190820083203.GB9855@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820083203.GB9855@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 20, 2019 at 09:32:03AM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 01, 2019 at 05:25:40PM +0200, Stefano Garzarella wrote:
> > When VMCI transport is used, if the guest closes a connection,
> > all data is gone and EOF is returned, so we should skip the read
> > of data written by the peer before closing the connection.
> 
> All transports should aim for identical semantics.  I think virtio-vsock
> should behave the same as VMCI since userspace applications should be
> transport-independent.

Yes, it is a good point!

> 
> Let's view this as a vsock bug.  Is it feasible to change the VMCI
> behavior so it's more like TCP sockets?  If not, let's change the
> virtio-vsock behavior to be compatible with VMCI.

I'm not sure it is feasible to change the VMCI behavior. IIUC reading the
Jorgen's answer [1], this was a decision made during the implementation.

@Jorgen: please, can you confirm? or not :-)

If it is the case, I'll change virtio-vsock to the same behavior.


Thanks,
Stefano

[1] https://patchwork.ozlabs.org/cover/847998/#1831400
