Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BB25A84C1
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiHaRv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiHaRvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:51:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5B045F78
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abvYViIvguPONv8Ppgd4Bbm0PP4cfU0m1JZK9rzmMe4=;
        b=KyjnEs2QJzowb1aSJDPMsCY1pfLUpovaXoU2ZlNAfvCdroPrYa/I1gQZ9M/c8iBqBnVCfB
        Po/chVPEDvRYTe8m/hJYw71Xsda2IP1G7PAKPJO6p2WH4Dpkf79EtM+Ns8/+JsOV1CxooI
        RMmh+ko2+/o0aYXFfzOeJJplTXOyCHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-ycFemNoFM7OjuzlH2u3S7A-1; Wed, 31 Aug 2022 13:51:13 -0400
X-MC-Unique: ycFemNoFM7OjuzlH2u3S7A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2299800124;
        Wed, 31 Aug 2022 17:51:12 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A6A7492C3B;
        Wed, 31 Aug 2022 17:51:10 +0000 (UTC)
Message-ID: <81ba71741c4098591f77de4275e2df4b558b19c0.camel@redhat.com>
Subject: Re: [PATCH 14/19] KVM: x86: Honor architectural behavior for
 aliased 8-bit APIC IDs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 20:51:04 +0300
In-Reply-To: <Yw+PRS2hScQd4ShB@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-15-seanjc@google.com>
         <5f6d99bc28fde0c48907991b6f67009430aea243.camel@redhat.com>
         <Yw+PRS2hScQd4ShB@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:41 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> > > -		if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> > > -			new->phys_map[xapic_id] = apic;
> > > +		if (kvm->arch.x2apic_format) {
> > > +			/* See also kvm_apic_match_physical_addr(). */
> > > +			if ((apic_x2apic_mode(apic) || x2apic_id > 0xff) &&
> > > +			    x2apic_id <= new->max_apic_id)
> > > +				new->phys_map[x2apic_id] = apic;
> > > +
> > > +			if (!apic_x2apic_mode(apic) && !new->phys_map[xapic_id])
> > > +				new->phys_map[xapic_id] = apic;
> > > +		} else {
> > > +			/*
> > > +			 * Disable the optimized map if the physical APIC ID is
> > > +			 * already mapped, i.e. is aliased to multiple vCPUs.
> > > +			 * The optimized map requires a strict 1:1 mapping
> > > +			 * between IDs and vCPUs.
> > > +			 */
> > > +			if (apic_x2apic_mode(apic))
> > > +				physical_id = x2apic_id;
> > > +			else
> > > +				physical_id = xapic_id;
> > > +
> > > +			if (new->phys_map[physical_id]) {
> > > +				kvfree(new);
> > > +				new = NULL;
> > > +				goto out;
> > Why not to use the same  KVM_APIC_MODE_XAPIC_FLAT |  KVM_APIC_MODE_XAPIC_CLUSTER
> > hack here?
> 
> The map's "mode" only covers logical mode (the cleanup patch renames "mode" to
> "logical_mode" to make this more clear).  There is no equivalent for dealing with
> the physical IDs.  Alternatively, a flag to say "physical map is disabled" could
> be added, but KVM already has to cleanly handle a NULL map and in all likelihood
> the logical map is also going to be disabled anyways.
> 
> Not to mention that APIC performance is unlikely to be a priority for any guest
> that triggers this code :-)
> 

Thanks for the explanation, that makes sense!

Best regards,
	Maxim Levitsky

