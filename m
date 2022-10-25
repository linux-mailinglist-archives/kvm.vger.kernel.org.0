Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F9360D61D
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 23:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbiJYV0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 17:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiJYV0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 17:26:04 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A521ABC785
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 14:26:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j12so12115281plj.5
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 14:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BGWr04V+lF6aWhbJp/Uoy9sOYrALVnSBN3Y8pRXJ1k4=;
        b=LdQSRDMo4JJXiBFQObJX4/tZ9izfN24AJBstnxjRMdZ1izJI+2DHzkRncteED1OM8i
         I3iX2jMpKfK3rAh2fD9WhhLy+dP2bpWtb6oCAyHm4cGNCy8Bm7R1HlOnz/VBvFWNDevp
         K4ar1SFCfoHZCN0CjYu8+ZEikR0PC5KTwqlj7X2K9z5xjtcSlRSj1ONmX2o2htyf4sT9
         xGU028Xqas2JAG+66gwK7xIASDWE+W8zZrYkS/PjX1G9RPxDL6GkZtGY6hLV5xnkSNwt
         tJ4vR1jfLNOc/QI+yCBkVWPYR9JmxkpZmV2FntTuEEgbTsdZqa9UOyYfxhUiOT/ZItGj
         FOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGWr04V+lF6aWhbJp/Uoy9sOYrALVnSBN3Y8pRXJ1k4=;
        b=clv4KmOHxRasuxNRpJ439EEnffwX5ea/G0lHKxFWHMmGghSsqyqkWtlMXgU5h/psMs
         okzELqxCA/ehpw77ZY/pvwSAUxaA6X+TbSiLhYVWzIPSUg2nRE9hpCYKB5eHAUL1IdmM
         m2h5rnIcGjJWBz2x6nQeyNJ823ZdDoppY1fl3Q694ZZOD+An9rvMWAf9YQKw+HrvkjvU
         tPxRrD5Gn5KcW9wSooBNn/1uLiZvfMJbYsYqXasiTpZxneXJT1KtL4HUqkirmI+PYaX5
         5hZJBCYXMFgpte9ArGO9E3Nci53jr0WCR7W5QP5oyawg4CGbElHESkeeWttRpjDNH2rL
         zqng==
X-Gm-Message-State: ACrzQf2JRWXfmSg6+sdqZRjmZpIJsUyqyi6H2pT4CfTGG/SvmpziyeVO
        Kjnfdqch1UKD8J1jJyfcSIyuuQ==
X-Google-Smtp-Source: AMsMyM4HtsuFLh5sOl5mxr3A6eeej2Rj7MHrQqomMmaqpDfXKwW6UZp8/eXMGqO9t73FTQZHw9vN9w==
X-Received: by 2002:a17:90b:38c5:b0:20d:2938:8123 with SMTP id nn5-20020a17090b38c500b0020d29388123mr303632pjb.59.1666733161290;
        Tue, 25 Oct 2022 14:26:01 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id mr21-20020a17090b239500b0020669c8bd87sm29866pjb.36.2022.10.25.14.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 14:26:00 -0700 (PDT)
Date:   Tue, 25 Oct 2022 21:25:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        jmattson@google.com
Subject: Re: [PATCH] KVM: x86: Do not expose the host value of CPUID.8000001EH
Message-ID: <Y1hUZYs7kz7JXmr7@google.com>
References: <20221022082643.1725875-1-pbonzini@redhat.com>
 <Y1gS6Z/kc+WfUsa3@google.com>
 <e906030e-a77d-468f-2c68-d6c643a768c4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e906030e-a77d-468f-2c68-d6c643a768c4@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25, 2022, Paolo Bonzini wrote:
> On 10/25/22 18:46, Sean Christopherson wrote:
> > On Sat, Oct 22, 2022, Paolo Bonzini wrote:
> > > Several fields of CPUID.8000001EH (ExtendedApicId in EAX[31:0],
> > > CoreId in EBX[7:0], NodeId in ECX[7:0]) vary on each processor,
> > > and it is simply impossible to fit the right values in the
> > > KVM_GET_SUPPORTED_CPUID API, in such a way that they can be
> > > passed to KVM_SET_CPUID2.
> > 
> > The same is true for 0xb and 0x1f, why delete 0x8000001e but keep those? I agree
> > that KVM_GET_SUPPORTED_CPUID can't get this right, but KVM can at least be
> > consistent with itself.
> 
> 0xb and 0x1f are already special cased because EDX is set to the X2APIC id.
> KVM knows how to do that unlike the NodeId and CoreId.

But KVM doesn't properly support 0xB/0x1F.  E.g. if usersepace regurgitates
KVM_GET_SUPPORTED_CPUID back into KVM_SET_CPUID2, all vCPUs will observe the same
x2APIC ID in EDX, and it will be a host x2APIC ID to boot.

KVM only handles the where userspace provides 0xB.1 (or 0x1F.1), the guest performs
CPUID with ECX>1, _and_ userspace doesn't provide the exact CPUID entry. 

I suppose one could argue that KVM needs to communicate to userspace that KVM
emulates the edge case behavior of CPUID 0xB and 0x1F, but I would argue that KVM
communicates that by announcing a max basic leaf >= 0xB/0x1F.
