Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7592B1CB1CA
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 16:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgEHO1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 10:27:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29085 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727854AbgEHO1i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 10:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588948057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CYevg34llcleChCJxzGI1QkRxIva9LaakKDngCZBbAk=;
        b=gQ0bdBwCPca6y192jbsU9edaxmqA+AwJ55Hw5FGyj0LNGPO8+vzw8i7MgvniA+zqatXPjT
        HvkRAPtX0Deb6EkSQK5We0PYjf6DbrcR0756GjgR1efaJh1wr3vY7V1NVve1ZXCg6wNlMs
        PNNIoPh2oB/36bwhQYghMOCEPiVTwLQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-wztoEUvbOHmSLqfbiSoXSQ-1; Fri, 08 May 2020 10:27:35 -0400
X-MC-Unique: wztoEUvbOHmSLqfbiSoXSQ-1
Received: by mail-qt1-f198.google.com with SMTP id d35so2055748qtc.20
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 07:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CYevg34llcleChCJxzGI1QkRxIva9LaakKDngCZBbAk=;
        b=VFGP0joBHqBovYzuDCd6Gc1lBJRUfgose1kGsr4VidtOgM1TOXquCq8zjCQk9Tqe84
         oqw1DMpjYb0sWBjFn4Nf7meYlzCZUcE4e9f0JKFCfkoVBZ3m22jyQhbI09stVyWhtbnn
         r2hviafwA6ib5CywqLK66V8M61G6Sy8XKS7tOE5+SuoiSiETcGuC6aCUkm1AEsYP7v63
         wLPrfhfS3kl4zY5PyYnZZgmBnt+bg/kS+tG92VedIanwadhfIF6VrzUoB2//4HETXDHT
         CR8i85nfmlJe/8kEInIqYulaPZ2OGJIavblSdfx8ZQUZA2uR5Vb6YTuOh26ZOLFM0rNF
         ulUA==
X-Gm-Message-State: AGi0PuZu7ilqDSQzxSeCBYigtp5SRzkZT9xYDVqHWarnd1iZ/56yQPuF
        sMnX1NumyYX4AZZUczn1fxgb8Mm5s4QVclSdeM/9fRI7JE7bbfbhAF6wWlRmd2iSdJH91rRBhgp
        KEacgFqkOy31Q
X-Received: by 2002:ac8:4990:: with SMTP id f16mr3249184qtq.307.1588948054916;
        Fri, 08 May 2020 07:27:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypKfyzNMjrHzXJcHVZXQfTevH1ye6Oks9gUBxO2AF+9yojDuWFLSKiaMNeDKuft0dw9T13j27Q==
X-Received: by 2002:ac8:4990:: with SMTP id f16mr3249156qtq.307.1588948054694;
        Fri, 08 May 2020 07:27:34 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 17sm1262912qkn.44.2020.05.08.07.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 07:27:33 -0700 (PDT)
Date:   Fri, 8 May 2020 10:27:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com
Subject: Re: [PATCH v2 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200508142732.GX228260@xz-x1>
References: <158871401328.15589.17598154478222071285.stgit@gimli.home>
 <158871569380.15589.16950418949340311053.stgit@gimli.home>
 <20200507214744.GP228260@xz-x1>
 <20200507160334.4c029518@x1.home>
 <20200507222223.GR228260@xz-x1>
 <20200507235633.GL26002@ziepe.ca>
 <20200508021656.GS228260@xz-x1>
 <0ee2fd04-d544-d03b-0a7c-90c22275aac9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0ee2fd04-d544-d03b-0a7c-90c22275aac9@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Jason!

On Fri, May 08, 2020 at 02:44:44PM +0800, Jason Wang wrote:
> Probably not, e.g when VMA is being split.

I see it now, thanks. :)

-- 
Peter Xu

