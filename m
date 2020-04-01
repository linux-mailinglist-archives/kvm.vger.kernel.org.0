Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262C619B8E8
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 01:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733293AbgDAXYK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Apr 2020 19:24:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732661AbgDAXYH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Apr 2020 19:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585783445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AUx9a9NcckmBmbGmt8k9ozR5fOJNJ4SVtbmheE+GSig=;
        b=E70eYhBpdmDCfFB/yyKtMy/HpSVH+Uiz0C3lCATNO3ypdcqTlPjPO8i2nWzW46IWW6I4UX
        1AtIoDpwQAaiCvt1qq35SXqfpLz8TQIYiPkVBPfFbEtSZBzdU6LxEf/+Fmk7KYVCQW1LZf
        2E5ibijXGfEj8gYcC1h0tr6OfbF1oK0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-gMfNOfpDNFeCU4TDlSYM2Q-1; Wed, 01 Apr 2020 19:24:04 -0400
X-MC-Unique: gMfNOfpDNFeCU4TDlSYM2Q-1
Received: by mail-qv1-f71.google.com with SMTP id v8so1106274qvr.12
        for <kvm@vger.kernel.org>; Wed, 01 Apr 2020 16:24:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AUx9a9NcckmBmbGmt8k9ozR5fOJNJ4SVtbmheE+GSig=;
        b=EUEAJmnogX7SoFqy0I2g/9il/cO9AHmPmkmd8cAwxOz6ms+gcBTnPHECYRzXEygvu0
         Y173wpT9WxVMP8E+xm2u5Z9p/X/cDoG9fgUh4hBd+Cq3U9wxz/1f/9/tXTJZKenO/PNa
         vp/9ZSHqNGUwEUN+68hOBPckxXivg8ZOWsTUi+UbJ51+l3TI/5xcCOIdMMBCaJPRA5Y1
         R1/0/pPdAJD3du+r+vwpDaUMncpVovvZPZ8uiwFUqvL534PLbQ729WZ8opGRCw8EzbM9
         Hfl8+Alif3MZ/LWTL/ZGRp5c+Z7JXOcdJU2lOtpf9w4iTKeMz0E5YxyOgQwLycBWXDT5
         AkQw==
X-Gm-Message-State: AGi0Pub6Dftpa1sElO3JC11yZdQ2mPVdV73Ok6BFOzWfm1MycvbSg+tn
        fj08RkdpnayRljX9QQ9tbT47ajt46IDC76Pnw2BxuNvKRpwx3RiQ7qdRRnFrC7HPb05b2ZRQsMj
        Rt9m/uzDtBMT9
X-Received: by 2002:ac8:1c17:: with SMTP id a23mr205330qtk.239.1585783443324;
        Wed, 01 Apr 2020 16:24:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypKs2sdWLelVFwa5wWDt7NfXNR0nWmfsLZw9a6O+nx9rOQNylkUrMsr/Rn+mFQtaWUda9LkQzA==
X-Received: by 2002:ac8:1c17:: with SMTP id a23mr205318qtk.239.1585783443115;
        Wed, 01 Apr 2020 16:24:03 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y41sm2502266qtc.72.2020.04.01.16.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 16:24:02 -0700 (PDT)
Date:   Wed, 1 Apr 2020 19:24:21 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 11/14] KVM: selftests: Introduce after_vcpu_run hook
 for dirty log test
Message-ID: <20200401232421.GA7174@xz-x1>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-12-peterx@redhat.com>
 <20200401070322.yqdp5g2amzlbftk6@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200401070322.yqdp5g2amzlbftk6@kamzik.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 01, 2020 at 09:03:22AM +0200, Andrew Jones wrote:
> On Tue, Mar 31, 2020 at 02:59:57PM -0400, Peter Xu wrote:
> > Provide a hook for the checks after vcpu_run() completes.  Preparation
> > for the dirty ring test because we'll need to take care of another
> > exit reason.
> > 
> > Since at it, drop the pages_count because after all we have a better
> > summary right now with statistics, and clean it up a bit.
> 
> I don't see what you mean by "drop the pages_count", because it's still
> there. But otherwise
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

I think the pages_count was dropped in some versions, at least the 1st
version when I wrote the commit, but it must have went back during one
of the rebases upon dirty_log_test.c...  To make it simple, I'll just
remove this paragraph and pick the r-b (assuming it's valid with that).

Thanks,

-- 
Peter Xu

