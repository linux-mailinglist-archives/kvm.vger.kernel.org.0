Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197824CA9D8
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 17:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiCBQKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 11:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiCBQKb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 11:10:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 865E3CB644
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 08:09:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646237387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/2VVs+jpaNG/J5zC1zTP1UGv1gQAxskIJSue9vwi7bY=;
        b=egXVIdzuzSV8ONfX+hTFe9p9K/X+y+HKjUHmA4NkGxfUwXkDLfbfKig+GZlz437TN+a19T
        kcp2a3KNhbNx5KlaHNdKkyeUcCr8e5BGEWBm0X5S9nIaGnkm+T4j9m+jyWTOH5H3HAGuwy
        PR7+idmuECLHOuOoXr/iCOc9n0Voh7g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-HMvxJ8wFPvyt0999PdDz8g-1; Wed, 02 Mar 2022 11:09:46 -0500
X-MC-Unique: HMvxJ8wFPvyt0999PdDz8g-1
Received: by mail-wr1-f70.google.com with SMTP id g17-20020adfa591000000b001da86c91c22so814397wrc.5
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 08:09:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/2VVs+jpaNG/J5zC1zTP1UGv1gQAxskIJSue9vwi7bY=;
        b=39iZ6x/WJP8lvRMoYh6h7GG+T7caQbABpue+Wv3i2dfp4c64cW4C5BaUzSFX8e/fqD
         dKubXEJAulIGLBW2P6GyxIjt5SHZorKfC54aU2rA7t0PtD2DkldLhS7MHZvcioNBtleR
         TYQ10Elvh5iXPUKzExk17kwHt5A5os/Bd7JdurSEvOge4ZgpRPzLtVFQGn+ylEWufWwT
         RCaumn37xAkYTAkPWP9taj2uwCbpopLadj+yjxEgqMI1mNsFfY5s4StmSeVZwDbh6FKm
         N9in/EqTiY7FuIA/g2gm5Q+VdoDgA1iiqmXqSzGbnprHOOQ2PLXDH3u9G0+aj8ist9O2
         Z/HQ==
X-Gm-Message-State: AOAM532NOAofp6WZyFyTw3ZGTNAOK7/khKGgTqBV43ml77zbPqUe0lxP
        KM03WBnCRZFiYEtP3qUd5cbgnu0cfxXszr1efL2QikK/fOBRRSXco8n2xLclWBpH+0CYNEqgHaY
        g1kLH+BeYelBa
X-Received: by 2002:a5d:484c:0:b0:1ef:c216:12e3 with SMTP id n12-20020a5d484c000000b001efc21612e3mr11900861wrs.13.1646237384994;
        Wed, 02 Mar 2022 08:09:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw90ZgDzHip3WR0j/kz08UsT1FI/BlJOLZiwaYx0i4o5rAuxPsiAmGZ5mdLez3oGCaiL2Thgw==
X-Received: by 2002:a5d:484c:0:b0:1ef:c216:12e3 with SMTP id n12-20020a5d484c000000b001efc21612e3mr11900830wrs.13.1646237384734;
        Wed, 02 Mar 2022 08:09:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id r12-20020a05600c2c4c00b003816932de9csm6125030wmg.24.2022.03.02.08.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 08:09:44 -0800 (PST)
Message-ID: <519f5e8e-18d1-43ac-ef90-0320d21c3a55@redhat.com>
Date:   Wed, 2 Mar 2022 17:09:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v11 00/45] Add AMD Secure Nested Paging (SEV-SNP) Guest
 Support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        brijesh.ksingh@gmail.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
References: <20220224165625.2175020-1-brijesh.singh@amd.com>
 <Yh99pBI/RwZY1yf7@nazgul.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh99pBI/RwZY1yf7@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 15:22, Borislav Petkov wrote:
> On Thu, Feb 24, 2022 at 10:55:40AM -0600, Brijesh Singh wrote:
>> This part of Secure Encrypted Paging (SEV-SNP) series focuses on the changes
>> required in a guest OS for SEV-SNP support.
> 
> So the first 4 are KVM material.
> 
> Paolo, what's the story here, are you gonna take them and give me an
> immutable branch or do you have another idea?

Sure: https://git.kernel.org/pub/scm/virt/kvm/kvm.git, branch svm-for-snp.

$ git log -4 --oneline --reverse
3c95d3fab229 KVM: SVM: Define sev_features and vmpl field in the VMSA
0c86f9cf27f7 KVM: SVM: Create a separate mapping for the SEV-ES save area
c5e0ec4c742d KVM: SVM: Create a separate mapping for the GHCB save area
88c955d1fc93 (HEAD -> kvm/svm-for-snp) KVM: SVM: Update the SEV-ES save area mapping

Paolo

