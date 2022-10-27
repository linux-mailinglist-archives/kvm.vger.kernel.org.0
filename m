Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87E2610492
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiJ0VjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 17:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiJ0VjH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 17:39:07 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FACD72EF2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 14:39:07 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h2so2930710pgp.4
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ba6LMfH9xvCq6MQ918tVELmUv4s1NaETeECQmHaDX6c=;
        b=gV8i9Bjkt+WevnsPUuT609K51j6tjDjXe7aJ8RG8HMzc6xIByghTTrEgDVOtnApb+w
         OsKIbbwvvEl7reyebSKb2hQY3rnkuZhrQBtU7Kx+P2Umnu/j+QarqFQseUd8Nnys8IHz
         7csZuNPs7ZxKoqAPHePrLDpQVWyYY8LWbMAnA+m58JoV3W27R3wvwX0jLHKP5ZslqTCr
         WUOBQ+sK0um7TQbkxow+WaupmhSPsOZwrEhuGI1VYr4GchAChXlcOSmFsKrA3BrmZKyY
         ibFmtWo/xoDvAp3PG9GN5gqIgSLV2NKCc0kZ6gmcC1mwTxke40T1qU4hq8HqigX8wNfH
         fh9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ba6LMfH9xvCq6MQ918tVELmUv4s1NaETeECQmHaDX6c=;
        b=XhXwniDX31McKsQFnkfKzQMMqs1ycsNa//J9BtgB9jfdY4e2pIlPjYH8xMVA5h6p63
         rsSYEDDClMACzfp/1OtOUOgxX8cuYo2MbHLEH8c43UGL5+opl9qc9vfof5pKUXJhFhzu
         hCTZABCL6ojB8VOFaTr86AMo5owI2xnGuN1nntLj3Kxr/dRwbA6aZuEusK4XJssK85h+
         eCoMZTIFLammchCl8NkKXDnUENks1sPBsk8b7/SmN5SgkGmh4xE8sfX911rY8y5OC8xe
         mlX1LTcN5DXmQdaLnlOwDX0JDVjjnOnICfRREquDqXj/qQUu4xxxcn7KD4ZXz0EDS2Y+
         qo6A==
X-Gm-Message-State: ACrzQf1Kmgqg/TN5J734PTn/ONGFaIH8zUCWIHQ4F95HIHR/MzwFsQXP
        wOApMXsKRovEW4LUTspP10gwJQ==
X-Google-Smtp-Source: AMsMyM5ZTTvdUEi8QASO3RlW7W/YsXAtueX1SZfhtjsxNmGVibJ1doihrRJRx4Vd/EBlgCxnChJU5A==
X-Received: by 2002:a63:2d81:0:b0:446:8d24:c90f with SMTP id t123-20020a632d81000000b004468d24c90fmr43158488pgt.160.1666906746726;
        Thu, 27 Oct 2022 14:39:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id v30-20020aa799de000000b0056bb191f176sm1658906pfi.14.2022.10.27.14.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 14:39:06 -0700 (PDT)
Date:   Thu, 27 Oct 2022 21:39:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 13/46] KVM: x86: Prepare kvm_hv_flush_tlb() to handle
 L2's GPAs
Message-ID: <Y1r6do4AVmAVvxeI@google.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <20221021153521.1216911-14-vkuznets@redhat.com>
 <Y1m0HCMgwJen/NnU@google.com>
 <87ilk5u1bt.fsf@ovpn-194-52.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ilk5u1bt.fsf@ovpn-194-52.brq.redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Fri, Oct 21, 2022, Vitaly Kuznetsov wrote:
> >> @@ -1908,6 +1909,12 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> >>  	 */
> >>  	BUILD_BUG_ON(KVM_HV_MAX_SPARSE_VCPU_SET_BITS > 64);
> >>  
> >> +	if (!hc->fast && is_guest_mode(vcpu)) {
> >
> > Please add a comment explaining why only "slow" hypercalls need to translate the
> > GPA from L2=>L1.
> >
> > With a comment (and assuming this isn't a bug),
> 
> This is intended,
> 
> For "slow" hypercalls 'hc->ingpa' is the GPA (or an 'nGPA' -- thus the
> patch) in guest memory where hypercall parameters are placed, kvm reads
> them with kvm_read_guest() later. For "fast" hypercalls 'ingpa' is a
> misnomer as it is not an address but the first parameter (in the 'tlb
> flush' case it's 'address space id' which we currently don't
> analyze). We may want to add a union in 'struct kvm_hv_hcall' to make
> this explicit.

Ya, a union would be helpful.  I'm pretty sure at some point I knew the "fast"
ingpa isn't actually a GPA, but obviously forgot that detail.
