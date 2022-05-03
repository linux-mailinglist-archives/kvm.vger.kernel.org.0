Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429BD5187FD
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiECPMt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiECPMs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:12:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE6D93A706
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 08:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651590552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UXPVU4l64mJ9z88JNBIKrjQOrWFO4bG6VcQhku3AdUw=;
        b=Uz8aoDlD11espS3XdsKz3EXrWn8B7Y8JjX4jzOimQsPDOSxTh6TfrbLysIy2w1aoUpBg3U
        YmDUoN1xcyz1hD3Q1ybsWj51sHaD1TT96NAlQecsA5Mc6rn79tQB2v/ty6bGtpb0HJZGUP
        j4elx2+6hkDFHkYvwXvaWYEkOE9YwXQ=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-U-AuB0DXM0WTpR38etefTA-1; Tue, 03 May 2022 11:09:08 -0400
X-MC-Unique: U-AuB0DXM0WTpR38etefTA-1
Received: by mail-pg1-f198.google.com with SMTP id bj12-20020a056a02018c00b003a9eebaad34so8552912pgb.10
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 08:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXPVU4l64mJ9z88JNBIKrjQOrWFO4bG6VcQhku3AdUw=;
        b=NA0iADgS+BEa3pzU/ISE4sHSIsdGD16nz3O0NGykBHhfoUqpHJY6obhe2BBgAn/DRO
         VtNKiZbUnDdQ5yQWVEAnoamTKWtX1JWD16IcKaBxypBFW0y5GH6yN91Ceic1/dOOqgaa
         DA+VSljrF/e8tIv70uhk4IkkdzHwqj/qaTOr/ilQRR8H3Wb3v9O/soBHzd8O8bCkLqxJ
         p5BdN1nkJ0DwOlQUoN0GJ17c3v9rNuELuLtmsz470X7htAfl20hWqm5h82chcLY8iTRJ
         jIRYgLerwD1Y/b6MMJV1d25MS9kZERjMy3FwSwVN+RBTxwHjeVEIR3yZ4V0zko/DHeMo
         r0kw==
X-Gm-Message-State: AOAM532KJjDwYZfJJdD87/dV0rvG0q7/gfe4p7sWnmPfwypjxvhbHqz+
        HcUB2Chk/jAbGibmbQM2k/kAsBXoIeeXLoxdsYKJJ8cxwjxs6B/HbQNaAiDEeoIiICBc+sE55Jk
        D3stqOs6847uw
X-Received: by 2002:a05:6602:148b:b0:657:c59b:f336 with SMTP id a11-20020a056602148b00b00657c59bf336mr6278365iow.141.1651585415252;
        Tue, 03 May 2022 06:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5aIdBIBzGMLhT/Cbn+kK6Cty125sDUVximgNiPqSFpIGft771bUpRY2pKZNA7iRqdg/OYKg==
X-Received: by 2002:a05:6602:148b:b0:657:c59b:f336 with SMTP id a11-20020a056602148b00b00657c59bf336mr6278359iow.141.1651585414962;
        Tue, 03 May 2022 06:43:34 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id j11-20020a056638052b00b0032b3a78177csm3897783jar.64.2022.05.03.06.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 06:43:34 -0700 (PDT)
Date:   Tue, 3 May 2022 09:43:31 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Shivam Kumar <shivam.kumar1@nutanix.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <YnExg/3McGZK3YdR@xz-m1.local>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YnBXuXTcX2OC6fQU@xz-m1.local>
 <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 12:52:26PM +0530, Shivam Kumar wrote:
> 
> On 03/05/22 3:44 am, Peter Xu wrote:
> > Hi, Shivam,
> > 
> > On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
> > > +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
> > > +{
> > > +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> > > +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> > > +	struct kvm_run *run = vcpu->run;
> > > +
> > > +	if (!dirty_quota || (pages_dirtied < dirty_quota))
> > > +		return 1;
> > > +
> > > +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> > > +	run->dirty_quota_exit.count = pages_dirtied;
> > > +	run->dirty_quota_exit.quota = dirty_quota;
> > Pure question: why this needs to be returned to userspace?  Is this value
> > set from userspace?
> > 
> 1) The quota needs to be replenished once exhasuted.
> 2) The vcpu should be made to sleep if it has consumed its quota pretty
> quick.
> 
> Both these actions are performed on the userspace side, where we expect a
> thread calculating the quota at very small regular intervals based on
> network bandwith information. This can enable us to micro-stun the vcpus
> (steal their runtime just the moment they were dirtying heavily).
> 
> We have implemented a "common quota" approach, i.e. transfering any unused
> quota to a common pool so that it can be consumed by any vcpu in the next
> interval on FCFS basis.
> 
> It seemed fit to implement all this logic on the userspace side and just
> keep the "dirty count" and the "logic to exit to userspace whenever the vcpu
> has consumed its quota" on the kernel side. The count is required on the
> userspace side because there are cases where a vcpu can actually dirty more
> than its quota (e.g. if PML is enabled). Hence, this information can be
> useful on the userspace side and can be used to re-adjust the next quotas.

I agree this information is useful.  Though my question was that if the
userspace should have a copy (per-vcpu) of that already then it's not
needed to pass it over to it anymore?

> 
> Thank you for the question. Please let me know if you have further concerns.
> 
> > > +	return 0;
> > > +}
> > The other high level question is whether you have considered using the ring
> > full event to achieve similar goal?
> > 
> > Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
> > gets full.  I think there's a problem that the ring size can not be
> > randomly set but must be a power of 2.  Also, there is a maximum size of
> > ring allowed at least.
> > 
> > However since the ring size can be fairly small (e.g. 4096 entries) it can
> > still achieve some kind of accuracy.  For example, the userspace can
> > quickly kick the vcpu back to VM_RUN only until it sees that it reaches
> > some quota (and actually that's how dirty-limit is implemented on QEMU,
> > contributed by China Telecom):
> > 
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1646243252.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=y6cIruIsp50rH6ImgUi28etki9RTCTHLhRic4IzAtLa62j9PqDMsKGmePy8wGIy8&s=tAZZzTjg74UGxGVzhlREaLYpxBpsDaNV4X_DNdOcUJ8&e=
> > 
> > Is there perhaps some explicit reason that dirty ring cannot be used?
> > 
> > Thanks!
> When we started this series, AFAIK it was not possible to set the dirty ring
> size once the vcpus are created. So, we couldn't dynamically set dirty ring
> size.

Agreed.  The ring size can only be set when startup and can't be changed.

> Also, since we are going for micro-stunning and the allowed dirties in
> such small intervals can be pretty low, it can cause issues if we can
> only use a dirty quota which is a power of 2. For instance, if the dirty
> quota is to be set to 9, we can only set it to 16 (if we round up) and if
> dirty quota is to be set to 15 we can only set it to 8 (if we round
> down). I hope you'd agree that this can make a huge difference.

Yes. As discussed above, I didn't expect the ring size to be the quota
per-se, so what I'm wondering is whether we can leverage a small and
constant sized ring to emulate the behavior of a quota with any size, but
with a minimum granule of the dirty ring size.

> 
> Also, this approach works for both dirty bitmap and dirty ring interface
> which can help in extending this solution to other architectures.

Is there any specific arch that you're interested outside x86?

Logically we can also think about extending dirty ring to other archs, but
there were indeed challenges where some pages can be dirtied without a vcpu
context, and that's why it was only supported initially on x86.

I think it should not be a problem for the quota solution, because it's
backed up by the dirty bitmap so no dirty page will be overlooked for
migration purpose, which is definitely a benefit.  But I'm still curious
whether you looked into any specific archs already (x86 doesn't have such
problem) so that maybe there's some quota you still want to apply elsewhere
where there's no vcpu context.

Thanks,

-- 
Peter Xu

