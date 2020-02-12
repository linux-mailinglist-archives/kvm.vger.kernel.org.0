Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A0E15ACC9
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 17:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbgBLQFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 11:05:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37115 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726351AbgBLQFw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Feb 2020 11:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581523551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BuiFEByjTOdPJEqSzlof5kdw7dqIMMEevCIbGA7HPC0=;
        b=Yac81R/QbVZtzb0O4XlwgRMfY9LIujb/A4tnVwYlFwTXsmEtH16ppjuaukI7icR+452CPT
        fBBvOISTxqC1Cc0SmwpY5BvB0AMMe78SAhAmtLAXyNWHDRpVujFO2WYZCFHulx54yvsU8E
        7ccZ6Vktp72UyTR4qLF0Hv0VVRCoPNs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-0JlccWaFOnm4F1R7JKk0IQ-1; Wed, 12 Feb 2020 11:05:48 -0500
X-MC-Unique: 0JlccWaFOnm4F1R7JKk0IQ-1
Received: by mail-qv1-f69.google.com with SMTP id b8so1669795qvw.3
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2020 08:05:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BuiFEByjTOdPJEqSzlof5kdw7dqIMMEevCIbGA7HPC0=;
        b=IV2zf1scwW2WhoQ3nLrLcvivwIRPBSFPgEA4bfqUof5FZRGzQQRrfx4hIE2RjpZfIo
         +y5Vzn4rs+8Ufmh5eZ7k/Tg2hjs7CYckSgkWKXAkDt3ApwXSsEGARTN9Mum/h0tiDynk
         KJeFb3MCozY62qwss1HA4b7mFF+Kd+G4gnYpmx09yfc48e8UoKpfWy4BCElDQLQQJrji
         MEYLCFYpxTOUSG3KZ+Kbg8LoiWdsNgd7Ns7Ja197nW62Ch0WxYnMBkyix/p0Mua0efge
         SyQcQ5DnHVclikWBfzXSbxm9omFFBeEWz/0ZUa06SsCa/Ko59gPQFSE5MPuGzwZPDbq4
         GEiw==
X-Gm-Message-State: APjAAAWbDFnQezdv5p/lhUReIkYXvOxfar8OyxChNBg9mUT8XnF189FS
        BGQ3FNXOgaQDeX2kcmOym+vWIXwYGPOk4WxGSR+mUsIwmr8SIEG8I0IHVBCvRSWznWbynoZmWpy
        ylp8gl6b2LGNu
X-Received: by 2002:aed:27de:: with SMTP id m30mr19941638qtg.151.1581523548285;
        Wed, 12 Feb 2020 08:05:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqwNDm2UfrjOrDJPfYOACk8aWkMeivWc5hd+gjQaGVxgdqdXt5A3hx1c1nj6DLkByyf8owdTKg==
X-Received: by 2002:aed:27de:: with SMTP id m30mr19941603qtg.151.1581523548025;
        Wed, 12 Feb 2020 08:05:48 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id v2sm376207qto.73.2020.02.12.08.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 08:05:46 -0800 (PST)
Date:   Wed, 12 Feb 2020 11:05:44 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v3 13/25] intel_iommu: modify x-scalable-mode to be string
 option
Message-ID: <20200212160544.GC1083891@xz-x1>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-14-git-send-email-yi.l.liu@intel.com>
 <20200211194331.GK984290@xz-x1>
 <A2975661238FB949B60364EF0F2C25743A1BA573@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1BA573@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 07:28:24AM +0000, Liu, Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> > Sent: Wednesday, February 12, 2020 3:44 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v3 13/25] intel_iommu: modify x-scalable-mode to be string
> > option
> > 
> > On Wed, Jan 29, 2020 at 04:16:44AM -0800, Liu, Yi L wrote:
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > Intel VT-d 3.0 introduces scalable mode, and it has a bunch of
> > > capabilities related to scalable mode translation, thus there are multiple
> > combinations.
> > > While this vIOMMU implementation wants simplify it for user by
> > > providing typical combinations. User could config it by
> > > "x-scalable-mode" option. The usage is as below:
> > >
> > > "-device intel-iommu,x-scalable-mode=["legacy"|"modern"]"
> > 
> > Maybe also "off" when someone wants to explicitly disable it?
> 
> emmm, I  think x-scalable-mode should be disabled by default. It is enabled
> only when "legacy" or "modern" is configured. I'm fine to add "off" as an
> explicit way to turn it off if you think it is necessary. :-)

It's not necessary.  It'll be necessary when we remove "x-" and change
the default value.  However it'll always be good to provide all
options explicitly in the parameter starting from when we design it,
imho.  It's still experimental, so... Your call. :)

-- 
Peter Xu

