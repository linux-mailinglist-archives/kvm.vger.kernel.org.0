Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D4765D069
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 11:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbjADKJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 05:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbjADKJW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 05:09:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E253167DB
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 02:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672826923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T7HpEnvLFRP9Wc3pt+AlvGW4vqhHztK91tjZWI6KGnk=;
        b=PtBrc/RZbxxUmJw5lut2UduhR2BQr3vLadYikWAdmoiK1WYznPYG4HKyhcZnbeX92Tn29q
        PrWzupVd8RhKwuHgwc3NdwKklCtMWR1+2pNvfIOpL8Rfggo47Br4b11btaZGXjQio73qDo
        iFYP+NP3F/kp2DdYL3QIuLvycLMyf0A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-461-kh2jA7IeOXeLm-cKcVDr0w-1; Wed, 04 Jan 2023 05:08:42 -0500
X-MC-Unique: kh2jA7IeOXeLm-cKcVDr0w-1
Received: by mail-wm1-f72.google.com with SMTP id k20-20020a05600c1c9400b003d9717c8b11so15934939wms.7
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 02:08:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T7HpEnvLFRP9Wc3pt+AlvGW4vqhHztK91tjZWI6KGnk=;
        b=gjZIk5dYXaqefj5bKXBYLRseCxvw3l3pXeKWZD5b+L4Rlzp9H8g5U1WDhK0V3PiyPy
         4aky2uNrVUMdGUdVul+ETwUZjgN8bukh256HFQlFW64C+Q1O7ic4qP1Onr1w0TbXrxYD
         cuqhGS4DNlsA3BP60VuKzLuOPhnZGjBQOG/5oUEjlhQSN17ZskHVIoFh0l9I4wt4EcCX
         nTVElVhMZChCPv8GeE6m7gIthL81Mc1qMjLJ+obedtr9mS9flrWPqWv+wEetdfMVBNir
         Ci1tyLPPO/TTBHu4S2oEMK/5+5GGDujBUhF22zU65p40ytspxozn+efUW3oQ5HLIpDd3
         njRQ==
X-Gm-Message-State: AFqh2kpcAEPYiVmu4783IFRfvUqqplKXAofnpQacOPDcZmStS3J0zfQ6
        C/ssyM0f99A4kYukc08KDbVDG5aHtjijh8uMY1Jgew3h0czdegjSMmff54UienjWffne2MGk1RT
        cpECfzXfMwgPJ
X-Received: by 2002:adf:ee83:0:b0:270:213a:b53d with SMTP id b3-20020adfee83000000b00270213ab53dmr28007203wro.33.1672826921388;
        Wed, 04 Jan 2023 02:08:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsGj8pewT8+sUCUsJf50Rb17SXAd6Z6tmNwzcf4m/yIhH3mB51TOWtZJwSua81YkACkPxNNdQ==
X-Received: by 2002:adf:ee83:0:b0:270:213a:b53d with SMTP id b3-20020adfee83000000b00270213ab53dmr28007190wro.33.1672826921142;
        Wed, 04 Jan 2023 02:08:41 -0800 (PST)
Received: from starship ([89.237.103.62])
        by smtp.gmail.com with ESMTPSA id u17-20020adfeb51000000b0026e94493858sm33190358wrn.106.2023.01.04.02.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 02:08:40 -0800 (PST)
Message-ID: <aba3787196caa812cee04f840dce26ac8a79eb7f.camel@redhat.com>
Subject: Re: [PATCH v4 28/32] KVM: SVM: Require logical ID to be power-of-2
 for AVIC entry
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 04 Jan 2023 12:08:38 +0200
In-Reply-To: <b002fd18c2abdfe5f4395be38858f461b3c76ac3.camel@redhat.com>
References: <20221001005915.2041642-1-seanjc@google.com>
         <20221001005915.2041642-29-seanjc@google.com>
         <f1f1a33134c739f09f5820b5a4973535f121c0da.camel@redhat.com>
         <b002fd18c2abdfe5f4395be38858f461b3c76ac3.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-12-29 at 10:27 +0200, mlevitsk@redhat.com wrote:
> On Fri, 2022-12-09 at 00:00 +0200, Maxim Levitsky wrote:
> > On Sat, 2022-10-01 at 00:59 +0000, Sean Christopherson wrote:
> > > Do not modify AVIC's logical ID table if the logical ID portion of the
> > > LDR is not a power-of-2, i.e. if the LDR has multiple bits set.  Taking
> > > only the first bit means that KVM will fail to match MDAs that intersect
> > > with "higher" bits in the "ID"
> > > 
> > > The "ID" acts as a bitmap, but is referred to as an ID because theres an
> > > implicit, unenforced "requirement" that software only set one bit.  This
> > > edge case is arguably out-of-spec behavior, but KVM cleanly handles it
> > > in all other cases, e.g. the optimized logical map (and AVIC!) is also
> > > disabled in this scenario.
> > > 
> > > Refactor the code to consolidate the checks, and so that the code looks
> > > more like avic_kick_target_vcpus_fast().
> > > 
> > > Fixes: 18f40c53e10f ("svm: Add VMEXIT handlers for AVIC")
> > > Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 30 +++++++++++++++---------------
> > >  1 file changed, 15 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 4b6fc9d64f4d..a9e4e09f83fc 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -513,26 +513,26 @@ unsigned long avic_vcpu_get_apicv_inhibit_reasons(struct kvm_vcpu *vcpu)
> > >  static u32 *avic_get_logical_id_entry(struct kvm_vcpu *vcpu, u32 ldr, bool flat)
> > >  {
> > >  	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
> > > -	int index;
> > >  	u32 *logical_apic_id_table;
> > > -	int dlid = GET_APIC_LOGICAL_ID(ldr);
> > > +	u32 cluster, index;
> > >  
> > > -	if (!dlid)
> > > -		return NULL;
> > > +	ldr = GET_APIC_LOGICAL_ID(ldr);
> > >  
> > > -	if (flat) { /* flat */
> > > -		index = ffs(dlid) - 1;
> > > -		if (index > 7)
> > > +	if (flat) {
> > > +		cluster = 0;
> > > +	} else {
> > > +		cluster = (ldr >> 4) << 2;
> > > +		if (cluster >= 0xf)
> > >  			return NULL;
> > > -	} else { /* cluster */
> > > -		int cluster = (dlid & 0xf0) >> 4;
> > > -		int apic = ffs(dlid & 0x0f) - 1;
> > > -
> > > -		if ((apic < 0) || (apic > 7) ||
> > > -		    (cluster >= 0xf))
> > > -			return NULL;
> > > -		index = (cluster << 2) + apic;
> > > +		ldr &= 0xf;
> > >  	}
> > > +	if (!ldr || !is_power_of_2(ldr))
> > > +		return NULL;
> > > +
> > > +	index = __ffs(ldr);
> > > +	if (WARN_ON_ONCE(index > 7))
> > > +		return NULL;
> > > +	index += (cluster << 2);
> > >  
> > >  	logical_apic_id_table = (u32 *) page_address(kvm_svm->avic_logical_id_table_page);
> > >  
> > 
> > Looks good.
> 
> I hate to say it but this patch has a bug:
> 
> We have both 'cluster = (ldr >> 4) << 2' and then 'index += (cluster << 2)'
> 
> One of the shifts has to go.


Sean, please don't forget to fix this isssue in the next patch series.
Best regards,
	Maxim Levitsky
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> > For future refactoring, I also suggest to rename this function to 'avic_get_logical_id_table_entry'
> > to stress the fact that it gets a pointer to the AVIC's data structure.
> > 
> > Same for 'avic_get_physical_id_entry'
> > 
> > And also while at it : the 'svm->avic_physical_id_cache', is a very misleading name,
> > 
> > It should be svm->avic_physical_id_table_entry_ptr with a comment explaining that
> > is is the pointer to physid table entry.
> > 
> > 
> > Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> > 
> > 
> > 
> > Best regards,
> > 	Maxim Levitsky
> 
> 


