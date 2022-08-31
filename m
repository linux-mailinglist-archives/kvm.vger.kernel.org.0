Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6B05A84AD
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 19:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiHaRsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 13:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHaRsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 13:48:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C92BD77F
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 10:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661968079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ng3kNHM++fJXXW5T0+rcub8oXdzUFxLTshdz07gNM6Q=;
        b=FYig2DCum/fdyMbCddB/EJKeeA6ELGBUjFsPSGqGB9ZeqEk4gMZ85nF23Ct4ActDwI7fRI
        jMWeJ+/dAWYba375MtcXnNCBn+1GQ42zPajowRnKVaNKOq7dEiDkT+IBS937aDHdvvsLEO
        Z8kiyjzdXQNT0EOE3NqDW+WUqGhnh8E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-nybyaUwMO1acLZusPPq0eQ-1; Wed, 31 Aug 2022 13:47:56 -0400
X-MC-Unique: nybyaUwMO1acLZusPPq0eQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECF8D1C14B61;
        Wed, 31 Aug 2022 17:47:55 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 579562026D4C;
        Wed, 31 Aug 2022 17:47:54 +0000 (UTC)
Message-ID: <d12df38c5b4ee493e63771000cbc4b723b4defe1.camel@redhat.com>
Subject: Re: [PATCH 03/19] Revert "KVM: SVM: Introduce hybrid-AVIC mode"
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Date:   Wed, 31 Aug 2022 20:47:53 +0300
In-Reply-To: <Yw+KDoSSKN0xgJW0@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
         <20220831003506.4117148-4-seanjc@google.com>
         <17e776dccf01e03bce1356beb8db0741e2a13d9a.camel@redhat.com>
         <Yw+KDoSSKN0xgJW0@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-08-31 at 16:19 +0000, Sean Christopherson wrote:
> On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > Remove SVM's so called "hybrid-AVIC mode" and reinstate the restriction
> > > where AVIC is disabled if x2APIC is enabled.  The argument that the
> > > "guest is not supposed to access xAPIC mmio when uses x2APIC" is flat out
> > > wrong.  Activating x2APIC completely disables the xAPIC MMIO region,
> > > there is nothing that says the guest must not access that address.
> > > 
> > > Concretely, KVM-Unit-Test's existing "apic" test fails the subtests that
> > > expect accesses to the APIC base region to not be emulated when x2APIC is
> > > enabled.
> > > 
> > > Furthermore, allowing the guest to trigger MMIO emulation in a mode where
> > > KVM doesn't expect such emulation to occur is all kinds of dangerous.
> > > 
> > > Tweak the restriction so that it only inhibits AVIC if x2APIC is actually
> > > enabled instead of inhibiting AVIC is x2APIC is exposed to the guest.
> > > 
> > > This reverts commit 0e311d33bfbef86da130674e8528cc23e6acfe16.
> > 
> > I don't agree with this patch.
> > 
> > When reviewing this code I did note that MMIO is left enabled which is kind
> > of errata on KVM side, and nobody objected to this.
> 
> I didn't object because I didn't read the patch.  I'm very much objecting now.
> 

And I am *very* much objecting to reverting this patch.

Best regards,
	Maxim Levitsky

