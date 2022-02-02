Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65AF4A7523
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiBBP6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 10:58:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345608AbiBBP6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 10:58:38 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3404AC06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 07:58:38 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id d5so20601178pjk.5
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 07:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Eu7UtipXKhJuZYLgqyG2W5R8xjd0BRCq/AEfSVc5hGw=;
        b=hmp1nsoHocmtnFFGGz009yO4BoykxPo3j9vOnfcmIMcTHC+cuOHcKvAKDAKcs78lnh
         zmDUFUpzX0UXrYA7gDHRqHO3Y7D4nF3ECQZnAkxAE3VEYfKLgOfKYZaciZldwXAhMOLH
         SalflKwf5cGSW4A6qVMDEzhNE4BtO7jbeD7Z7DbPawuWuN5CMNF5g4zbQj/mP2l1Sy+i
         vakSEHh4WQYsFPCevjt9U0PITcoAPERscIfFRgcyUWwSckWOQ1eX3DOsifIi5pJ6V2ai
         OqtI0t6hPQbSpzDIuK0yJGcUqoDXEx9Iaqk8XtQt8bxRwo8vhHN4vbOYTjcUI6w5Adun
         phrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eu7UtipXKhJuZYLgqyG2W5R8xjd0BRCq/AEfSVc5hGw=;
        b=xso5klPsDzBzlWSYATarFk7Puqn74lJolsOb7F9F6PuVRc79FC9uiV7bs9KOuyTxL6
         bwyud+onxFd7L6w4RRxZNatpaoghR8w61FGUZUobmdSkZANoZ4H8N5OdCOENl4NGqIHY
         aIuCTx8ljOsPUL1jK4jVjoCA96UglKbc522uBhy+WYACiuS4qbeKJWtPbLg+pONwmBYr
         Fwzc3LPUgiv1vkEirc1GsyBEGVZ+WTpIaVzT3K+RB+ga9KbIxuNOTeQFJ4DCM73OU9o1
         te9XhXBL2hFja4x/ZBCLSnewifvfi6xrEZvGJe7bx7jWcuTgbGJM/C0osPTY1Y2viGiR
         oLYg==
X-Gm-Message-State: AOAM531hcBudnRp0vPQ+le+oiswM7u2ItqSFuZAU/iI5UruHoEZgBpBe
        Lis23TjuJvXLEsPvyY8iXZvQhA==
X-Google-Smtp-Source: ABdhPJzSqoZaSZ+RrUPC3NhpZBERPaO2f8YjUHAKOavOg0CnjZksj+S47/oBnsHLxIPLmspox/I8/g==
X-Received: by 2002:a17:90b:3b52:: with SMTP id ot18mr8921394pjb.34.1643817517519;
        Wed, 02 Feb 2022 07:58:37 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm24958295pfn.19.2022.02.02.07.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:58:36 -0800 (PST)
Date:   Wed, 2 Feb 2022 15:58:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        mlevitsk@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com
Subject: Re: [PATCH v4 0/3] svm: avic: Allow AVIC support on system w/
 physical APIC ID > 255
Message-ID: <YfqqKSARjNGx52cJ@google.com>
References: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202041112.273017-1-suravee.suthikulpanit@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 01, 2022, Suravee Suthikulpanit wrote:
> Originally, AMD SVM AVIC supports 8-bit host physical APIC ID.
> However, newer AMD systems can have physical APIC ID larger than 255,
> and AVIC hardware has been extended to support upto 12-bit host
> physical APIC ID.
> 
> This series introduces a helper function in the APIC subsystem to get
> the maximum physical APIC ID allowing the SVM AVIC driver to calculate
> the proper size to program the host physical APIC ID in the AVIC
> physical APIC ID table entry.

NAK to this version.  Please wait until discussion on the previous versions comes
to a stop.  If a reviewer is non-responsive then that's one thing, but we were
literally just discussing this yesterday.
