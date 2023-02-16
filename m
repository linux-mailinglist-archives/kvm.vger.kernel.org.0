Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83869A027
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 23:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjBPW4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 17:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBPW4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 17:56:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9C838E96
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676588152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WsJAQPdgfmyRCdBIfmljb6PSA+KVi0kNYA3whbtDzGE=;
        b=DHRiAYSjcsDDcxs8PoOioXboGPqApCxe10kW+xOpIZvMy4uR5zwDVDlSYD8DRskieVrfCL
        cbswfVfdgP2WHEobYyQtbo6CpuGPVq6p3ima6AM9RgroyIz9lArqCE1LpD9P2OExe28e2f
        EycCJ0HKFBZogPJeSPkh1ASWzbTtBxg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-1Ro_eLD4Oay3qxqukJWRew-1; Thu, 16 Feb 2023 17:55:50 -0500
X-MC-Unique: 1Ro_eLD4Oay3qxqukJWRew-1
Received: by mail-qv1-f72.google.com with SMTP id r10-20020a0562140c8a00b0056ed45f262dso1958761qvr.11
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:55:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsJAQPdgfmyRCdBIfmljb6PSA+KVi0kNYA3whbtDzGE=;
        b=T2a7BqjcyfxzfQRtkS374evYF/EHGur5vN5yTPomVo+E9t/dR/TwMGGd42oZiSlSv5
         xkNyyZ3U4qqZvSNAmlSkc4x52vljijDzOiymsksGgbPWXYRFieO0hvTfqVjpcbR0tmqA
         kJNhBlmkcFM4fKE5kLyH2YxyQeDRyCoPR4REk8Yv1H3lOqx9qOL0uS+Wewh7DXQCbinA
         a3Apt3xtNSGsW+WGty75dHj3NmuKjJnvMltsJVgaIXo3KunRR9LAJdq/loCOpGD/Aobj
         VAfKNVM00kyL0bNz2pAw6/uuCyuoZjsgFa+mCodTO7/JheZUlR4MPwghlMTfM4J1s0+d
         crpQ==
X-Gm-Message-State: AO0yUKUylF/PbYXgqNSLN5Z1EduN4RI1HO9zM7Ykg/lpvruuVor/Pirc
        Vwp7T+d2OxACNzHso/gKlCm5W/N/664J9W5dVCXnHZ8StpH8qLk9HsuaSCIznVcHaiQFv36U+Dc
        g3u3xUWQE23Re
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr14520331qte.5.1676588150334;
        Thu, 16 Feb 2023 14:55:50 -0800 (PST)
X-Google-Smtp-Source: AK7set+WU3Uxar4FQEfigjScvOSNMorobMDegsajbzAUL2/ymdc3m3y2cKgUDCySPQH/BrPQuXkBAg==
X-Received: by 2002:a05:622a:1052:b0:3b5:87db:f979 with SMTP id f18-20020a05622a105200b003b587dbf979mr14520310qte.5.1676588150092;
        Thu, 16 Feb 2023 14:55:50 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-56-70-30-145-63.dsl.bell.ca. [70.30.145.63])
        by smtp.gmail.com with ESMTPSA id 2-20020ac82082000000b003b2d890752dsm1301870qtd.88.2023.02.16.14.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 14:55:49 -0800 (PST)
Date:   Thu, 16 Feb 2023 17:55:48 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Anish Moorthy <amoorthy@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Subject: Re: [PATCH 6/8] kvm/x86: Add mem fault exit on EPT violations
Message-ID: <Y+60dIGWIXEuHpwW@x1n>
References: <20230215011614.725983-1-amoorthy@google.com>
 <20230215011614.725983-7-amoorthy@google.com>
 <Y+0VK6vZpMqAQ2Dc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+0VK6vZpMqAQ2Dc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Sean,

On Wed, Feb 15, 2023 at 09:23:55AM -0800, Sean Christopherson wrote:
> > @@ -4230,9 +4231,25 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
> >  	}
> >  
> >  	async = false;
> > -	fault->pfn = __gfn_to_pfn_memslot(slot, fault->gfn, false, false, &async,
> > -					  fault->write, &fault->map_writable,
> > -					  &fault->hva);
> > +	mem_fault_nowait = memory_faults_enabled(vcpu->kvm);
> > +
> > +	fault->pfn = __gfn_to_pfn_memslot(
> > +		slot, fault->gfn,
> > +		mem_fault_nowait,
> 
> Hrm, as prep work for this series, I think we should first clean up the pile o'
> bools.  This came up before when the "interruptible" flag was added[*].  We punted
> then, but I think it's time to bite the bullet, especially since "nowait" and
> "async" need to be mutually exclusive.
> 
> [*] https://lore.kernel.org/all/YrR9i3yHzh5ftOxB@google.com

IIUC at that time we didn't reach a consensus on how to rework it, and the
suggestion was using a bool and separate the cleanup (while the flag
cleanup got NACKed..), which makes sense to me.

Personally I like your other patch a lot:

https://lore.kernel.org/all/YrTNGVpT8Cw2yrnr@google.com/

The question is, after we merge the bools into a flag, do we still need a
struct* anyway?  If we can reach a consensus, I'll be happy to continue
working on the cleanup (by picking up your patch first).  Or if Anish would
like to take it over in any form that'll be also perfect.

Thanks,

-- 
Peter Xu

