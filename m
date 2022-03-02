Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4EF4CAB64
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243747AbiCBRTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243740AbiCBRTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:19:22 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4AC7E9D;
        Wed,  2 Mar 2022 09:18:38 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id y15-20020a4a650f000000b0031c19e9fe9dso2628486ooc.12;
        Wed, 02 Mar 2022 09:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cwLG9kTnhX2GqkeQf8KU8q/jw+pGFKDaUnw1ajiL6WA=;
        b=Ph+RbvL6FanSOSwQxZUf26lIJLD1mcS3h0APBOTmjL0rL8sL58KJLFAGiWptkhBp5f
         z5ZgRL+10UyFNfksj//XcL9pJCGCD6qYN9UCdiS8SIRssuw3151XtoQsw11ASk+hEEQs
         7UWDCkB2pqpxxqJssBKAq8izDqfQt3z4hlBl78kUt3xIc/snzVPeNxjkge/VZOSWHaLR
         40GJ26I2rx8DmUJSGIItZ1LqEOGI32dpoM2HZZb4qQv4d7UgQ4MF7I8MHghj3+jwXqm8
         sv+M1n5AKMMjPdnNP0hgHgFXQ8GowrimHS7zngUz0tPwpAWrZaH9Fx1B11OQPzUNAcML
         C9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cwLG9kTnhX2GqkeQf8KU8q/jw+pGFKDaUnw1ajiL6WA=;
        b=LNvUgFBFAZzAONYCafiqBWiLhv+0lmjkf3GptQLDrnFHQsCRQ+yln6WR4wYH10xY15
         8z/imfVYtVk+3+woCjA84ao9eqfzlM/+9oRiEzqgNcZK9FCA9kqoA8I1eoM/qIIt4RKW
         AqxCCBt74+G3p4w9EZAQcqARZUf0rJrN2GanX8N19VjNTCOb/4AmneuE7tACvd6m49/U
         OHwY2aHcnPkEyAFWa0+zWMRHyJMRO2jATngrdPb3vWd2FPdpiDeK3tlRjGVX9WZ9iI7H
         RXb3auryrvuiAA/FHYquK9JSZaRk70hVYwdcAFcLOanPj0aC+sCXilLskJAl5/IuMOEX
         4IDA==
X-Gm-Message-State: AOAM533xeKufT9EOljbSplasytugfV5W+3mBj1iYIWtAnoI/qu5f+5uv
        YVg1qi9UMwEqKgxD/SCS8uqTenpnSso=
X-Google-Smtp-Source: ABdhPJzaTl0H10yq5ZoNdnQwMSeiQ6SyTqU2PuD1HxWe6SG7t/bXRnCfIG9yWUnPnd3RZp+WwWGEPA==
X-Received: by 2002:a05:6870:c987:b0:d7:3d45:6692 with SMTP id hi7-20020a056870c98700b000d73d456692mr683349oab.34.1646241517676;
        Wed, 02 Mar 2022 09:18:37 -0800 (PST)
Received: from localhost ([98.200.8.69])
        by smtp.gmail.com with ESMTPSA id m7-20020a9d6447000000b005acf7e4c507sm7983689otl.20.2022.03.02.09.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 09:18:37 -0800 (PST)
Date:   Wed, 2 Mar 2022 09:18:35 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Don't cast parameter in bit operations
Message-ID: <Yh+m65BSfQgaDFwi@yury-laptop>
References: <20220223164420.45344-1-andriy.shevchenko@linux.intel.com>
 <20220224123620.57fd6c8b@p-imbrenda>
 <3640a910-60fe-0935-4dfc-55bb65a75ce5@linux.ibm.com>
 <Yh+Qw6Pb+Cd9JDNa@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh+Qw6Pb+Cd9JDNa@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 05:44:03PM +0200, Andy Shevchenko wrote:
> On Thu, Feb 24, 2022 at 01:10:34PM +0100, Michael Mueller wrote:
> > On 24.02.22 12:36, Claudio Imbrenda wrote:
> 
> ...
> 
> > we do that at several places
> 
> Thanks for pointing out.
> 
> > arch/s390/kernel/processor.c:	for_each_set_bit_inv(bit, (long
> > *)&stfle_fac_list, MAX_FACILITY_BIT)
> 
> This one requires a separate change, not related to this patch.
> 
> > arch/s390/kvm/interrupt.c:	set_bit_inv(IPM_BIT_OFFSET + gisc, (unsigned long
> > *) gisa);
> 
> This is done in the patch. Not sure how it appears in your list.
> 
> > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > sca->mcn);
> > arch/s390/kvm/kvm-s390.c:		set_bit_inv(vcpu->vcpu_id, (unsigned long *)
> > &sca->mcn);
> 
> These two should be fixed in a separate change.
> 
> Also this kind of stuff:
> 
> 	bitmap_copy(kvm->arch.cpu_feat, (unsigned long *) data.feat,
> 	            KVM_S390_VM_CPU_FEAT_NR_BITS);
> 
> might require a new API like
> 
> bitmap_from_u64_array()
> bitmap_to_u64_array()
> 
> Yury?

If BE32 is still the case then yes.
