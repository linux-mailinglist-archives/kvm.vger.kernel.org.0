Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FC0694E36
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 18:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjBMRia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 12:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjBMRi2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 12:38:28 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED02E14EAE
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:38:27 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gd1so1857511pjb.1
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 09:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vJp65np+MGO0NID8y/YWfa1C8DDxZtkxtNf/Cu1vhlM=;
        b=hkNIEgDxuKbyGmGlthtQFayuibvuc99fHb2GNTtA2S0RB/fJ/TYO1ibq66wNsrbfgb
         kEI85FAcfDkf+9WvIpViR+sW/XVmGwXOBFItwnfWfypFaqvJ3XZJxPOSLEyzIDUuV+Gh
         iBAikfMf90Ko+vkNPfQeMuMDKpgDzH14jEd20ZKmpGkjH664Yqt+ytsr5NPCuzkicSwW
         gIjIemux+VLL6vGKx9G1vlKDlTAburPa4hm3fcmbXBocEFYw6ok6uiQd7tmENHqa5Lnk
         WP+K1zsIY1xZmIveoX4tVByhVV16XHthdBiZjAbDiX1uuct0IbZsnmalT93RhX/8GWNO
         Q92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJp65np+MGO0NID8y/YWfa1C8DDxZtkxtNf/Cu1vhlM=;
        b=PT/J2EuUxwz2xTi87CVkHt1G1TwmU9TzyxyQ0sKiye5Bn9CDSP8Ky57SYAmqge+vaG
         Q6u5fNg/+K426jvct0o+jpnG6p3+0MP5sifAQY45GJ6AmnTq/UrMPuCPkJFYfYZDaMpF
         c6bM15SS8CLTNmV0BRnbhKGcTh4tBR6BOQWTNollIp6UjbCAmf4inIRo5+ffnUi7xkZD
         vlFWW3d+/cd9DU4YAhpLfu3smsOc1L1aDpGz2WrvCTVlClLiOp3wGkEworJIQQbjr7Zd
         oOm24n6s0XHujLsZJm6qJ4cZ1y2araGP9Bj7muaSMNXlq9PYcherIIWzeCqDsLlqqiBj
         kdLw==
X-Gm-Message-State: AO0yUKU8eGIZ5Lg0We/5iIyjZq14u7w3QoVdErnMOxzOJaqwz5cVEBw6
        t+j8AnPXyQQb+9UN2MZd40dSgQ==
X-Google-Smtp-Source: AK7set+uhCt/hf2ILQA1oXNeDlh/QkZdYpFPuz7irWazGWeHzuEdvWrKsMBiBc4Vq9ittzuLo1u50w==
X-Received: by 2002:a17:902:e542:b0:198:af4f:de0b with SMTP id n2-20020a170902e54200b00198af4fde0bmr460281plf.11.1676309907175;
        Mon, 13 Feb 2023 09:38:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mp6-20020a17090b190600b00233c9eb64f3sm4239867pjb.47.2023.02.13.09.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 09:38:26 -0800 (PST)
Date:   Mon, 13 Feb 2023 17:38:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
Message-ID: <Y+p1j7tYT+16MX6B@google.com>
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 10, 2023, Jeremi Piotrowski wrote:
> Hi Paolo/Sean,
> 
> We've noticed that changes introduced in "KVM: x86/mmu: Overhaul TDP MMU
> zapping and flushing" conflict with a nested Hyper-V enlightenment that is
> always enabled on AMD CPUs (HV_X64_NESTED_ENLIGHTENED_TLB). The scenario that
> is affected is L0 Hyper-V + L1 KVM on AMD,

Do you see issues with Intel and HV_X64_NESTED_GUEST_MAPPING_FLUSH?  IIUC, on the
KVM side, that setup is equivalent to HV_X64_NESTED_ENLIGHTENED_TLB.

> IIRC, KVM side always uses write-protected translation table to shadow and so
> doesn't meet such issue with the commit.

This is incorrect.  KVM write-protects guest PTEs that point at 2MiB and larger
pages, but 4KiB PTEs are allowed to become "unsync" and KVM's shadow NPT/EPT entries
are synchronized with the guest only on a relevant TLB.

I know of at least one non-KVM-hypervisor TDP TLB flushing bug that was found
specifically because of KVM's infinite software TLB.  That doesn't mean that this
isn't a KVM bug, I just want to call out that KVM-on-KVM should be capable of
detecting KVM-as-L1 TLB bugs, at least on Intel/VMX/EPT (KVM's nested SVM support
is woefully naive from a TLB flushing perspective and synchronizes guest PTEs
before every nested VM-Entry to L2).
