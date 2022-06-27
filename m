Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3946355C73F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbiF0Wzc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 18:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiF0Wza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 18:55:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F33B3C7
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 15:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656370529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7bjvkZS62junHocgoqnop/+MjbdA1dU+9EW2nxvBCLc=;
        b=K5auKYUzRxXyhHd3x6lJn3SRyeDXtGIwpJhTCjrGC+qI2wQe8qgRYk8sdwSW+KbcULsYnu
        kA2h+P+wOU8kFg7yMmcij3L5QzlpcXyEKcmwhjK30KU3r5NdJ2GwFj/G2b3Swk+LpSuG4k
        hcE7gJhrTqPFrt6MYe6sotO3rDKx6SA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-3vvwLABbPkyzyMQG_h41LA-1; Mon, 27 Jun 2022 18:55:27 -0400
X-MC-Unique: 3vvwLABbPkyzyMQG_h41LA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1073A1C05EA2;
        Mon, 27 Jun 2022 22:55:27 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC331415108;
        Mon, 27 Jun 2022 22:55:24 +0000 (UTC)
Message-ID: <d761ef283bc91002322f3cd66c124d329c25f04f.camel@redhat.com>
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete
 x2AVIC IRQs when possible
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, joro@8bytes.org, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com
Date:   Tue, 28 Jun 2022 01:55:23 +0300
In-Reply-To: <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
         <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
         <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-06-24 at 18:41 +0200, Paolo Bonzini wrote:
> On 5/19/22 12:27, Suravee Suthikulpanit wrote:
> > +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
> > +			 * or more than 1 bits, we cannot match just one vcpu to kick for
> > +			 * fast path.
> > +			 */
> > +			if (!first || (first != last))
> > +				return -EINVAL;
> > +
> > +			apic = first - 1;
> > +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
> > +				return -EINVAL;
> 
> Neither of these is possible: first == 0 has been cheked above, and
> ffs(icrh & 0xffff) cannot exceed 15.  Likewise, cluster is actually
> limited to 16 bits, not 20.
> 
> Plus, C is not Pascal so no parentheses. :)
> 
> Putting everything together, it can be simplified to this:
> 
> +                       int cluster = (icrh & 0xffff0000) >> 16;
> +                       int apic = ffs(icrh & 0xffff) - 1;
> +
> +                       /*
> +                        * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> +                        * contains anything but a single bit, we cannot use the
> +                        * fast path, because it is limited to a single vCPU.
> +                        */
> +                       if (apic < 0 || icrh != (1 << apic))
> +                               return -EINVAL;
> +
> +                       l1_physical_id = (cluster << 4) + apic;
> 
> 
> > +			apic_id = (cluster << 4) + apic;

Hi Paolo and Suravee Suthikulpanit!

Note that this patch is not needed anymore, I fixed the avic_kick_target_vcpus_fast function,
and added the support for x2apic because it was very easy to do
(I already needed to parse logical id for flat and cluser modes)

Best regards,
	Maxim Levitsky

