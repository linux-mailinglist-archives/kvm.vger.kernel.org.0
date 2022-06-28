Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFF755DE34
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbiF1JAQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245008AbiF1JAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 05:00:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30251CE1E
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 02:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656406810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFhHKd2mZ072DWQopFu9vA14GdgydCHXDdzCaVdjvH4=;
        b=dUVHV+iSEpqZf7orN/O2s7Kx8VBL9YMKeUFbbwJRKB/cAYLBrr0Q/GtW06ijxbnKxe9mn9
        mOsPq1h6h2C1o0dKblVKwNljvmp5jhStaqjdySC1E8nBKaA/v0COIYOA3QqNxIypl5bd3a
        yvOxg4aSfOHDq4tTgMngH9ceiuBmdW0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-KauYkGl2OPumMcY0nzX0vw-1; Tue, 28 Jun 2022 04:59:58 -0400
X-MC-Unique: KauYkGl2OPumMcY0nzX0vw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 518BC101A588;
        Tue, 28 Jun 2022 08:59:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FA432026D64;
        Tue, 28 Jun 2022 08:59:56 +0000 (UTC)
Message-ID: <df464fd9b3c66059d7065acc52594d27dfe52448.camel@redhat.com>
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 28 Jun 2022 11:59:55 +0300
In-Reply-To: <9f3ffe16-2516-d4ec-528e-6347ef884ad5@amd.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
         <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
         <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
         <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
         <9f3ffe16-2516-d4ec-528e-6347ef884ad5@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-06-28 at 09:35 +0700, Suthikulpanit, Suravee wrote:
> 
> On 6/28/2022 5:55 AM, Maxim Levitsky wrote:
> > On Fri, 2022-06-24 at 18:41 +0200, Paolo Bonzini wrote:
> > > On 5/19/22 12:27, Suravee Suthikulpanit wrote:
> > > > +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
> > > > +			 * or more than 1 bits, we cannot match just one vcpu to kick for
> > > > +			 * fast path.
> > > > +			 */
> > > > +			if (!first || (first != last))
> > > > +				return -EINVAL;
> > > > +
> > > > +			apic = first - 1;
> > > > +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
> > > > +				return -EINVAL;
> > > 
> > > Neither of these is possible: first == 0 has been cheked above, and
> > > ffs(icrh & 0xffff) cannot exceed 15.  Likewise, cluster is actually
> > > limited to 16 bits, not 20.
> > > 
> > > Plus, C is not Pascal so no parentheses. :)
> > > 
> > > Putting everything together, it can be simplified to this:
> > > 
> > > +                       int cluster = (icrh & 0xffff0000) >> 16;
> > > +                       int apic = ffs(icrh & 0xffff) - 1;
> > > +
> > > +                       /*
> > > +                        * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> > > +                        * contains anything but a single bit, we cannot use the
> > > +                        * fast path, because it is limited to a single vCPU.
> > > +                        */
> > > +                       if (apic < 0 || icrh != (1 << apic))
> > > +                               return -EINVAL;
> > > +
> > > +                       l1_physical_id = (cluster << 4) + apic;
> > > 
> > > 
> > > > +			apic_id = (cluster << 4) + apic;
> > 
> > Hi Paolo and Suravee Suthikulpanit!
> > 
> > Note that this patch is not needed anymore, I fixed the avic_kick_target_vcpus_fast function,
> > and added the support for x2apic because it was very easy to do
> > (I already needed to parse logical id for flat and cluser modes)
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> 
> Understood. I was about to send v7 to remove this patch from the series, but too late. I'll test the current queue branch and provide update.

Also this really needs a KVM unit test, to avoid breaking corner cases like
sending IPI to 0xFF address, which was the reason I had to fix the 
avic_kick_target_vcpus_fast.

We do have 'apic' test in kvm unit tests,
and I was already looking to extend it to cover more cases and to run it with AVIC's
compatible settings. I hope I will be able to do this this week.

Best regards,
	Maxim Levitsky


> 
> Best Regards,
> Suravee
> 


