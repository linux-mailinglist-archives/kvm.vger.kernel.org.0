Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508A17D15FC
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 20:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjJTSwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 14:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjJTSwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 14:52:46 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7D8114
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 11:52:41 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6be1bc5aa1cso1079297b3a.3
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 11:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697827961; x=1698432761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DTSJspe6v544wqJ5pbefnUtP+UIVc6mp9wCNcSSACRk=;
        b=RoCP1pG0OtI7hvdVowuM0qQ6phFQYo3OugHx+x7/7oVjs9w7qE0jEkWtH8pt68apDM
         oGOdL5H3y0eizlDhq2TPQ8JKwJAhXNL5y8vgv/O0HRWG+zG4N60iwipCQbHBCMW0i3Lm
         /eOC+OcO5CNaV3sPRo415/1ej5IbUiEq4NNxCPVSboUKAFRL992eNDNx1nY5XB8HWxV+
         yfMCOcVNzMuvJfg5PLTnVwAIF14xk7Oj9wllDIRhYMOQXKLBCYqUHR2FpZ6LTRj+m+Pb
         tnf/zF4SOIYE9npCXIc88mkpT+Mqs4ua4J2hgKXCh4GG2uQ3ktAz53Huo0q61lel2MDh
         8qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697827961; x=1698432761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DTSJspe6v544wqJ5pbefnUtP+UIVc6mp9wCNcSSACRk=;
        b=Z4MjjEWaZrc03oj1dMMph9JMpZR23C8WX1jzhH/3BB7h01yZzCETKF6GH8XebrLV8Y
         jSLQwvdD97qz3ZWNPwRGMSpm34d58nsWNqybaip22msx78Cft8coL2mdHFkdaVlRG/G4
         KXtPL/yF+7hMisXLYNs+KnRTNersCqxnwWypO3USlo0YFZTvSTgsGYpCoUWTtQwg/zwD
         r07LhYZC/MmCGqFMbMyXEt3hD3PRcJK+ONx3Keaoefrjquu1iSkQNpkYF+9YWhlOHlq1
         jESggmJPrrqqYCrjEgnaL9fEz5NkIXUxaXHSdR/99RE4uCsI/MPhilI5ovsNV+bH71z5
         HVrA==
X-Gm-Message-State: AOJu0YxDxPiiGMVh91k8YHWkaDqy+D4eDB1WUc++84Sswq9w8QPtuXrT
        ry25HDGztorSzFqomK1aH3ya1Q==
X-Google-Smtp-Source: AGHT+IGtSG0CdpLv7VLLWwthXlAkWWoVEYHlOSNc8IsWEjTOOD4D2zAepXWaocbQwjctb1/FcypFIQ==
X-Received: by 2002:a05:6a00:24d1:b0:6be:2720:16a5 with SMTP id d17-20020a056a0024d100b006be272016a5mr3028317pfv.33.1697827961208;
        Fri, 20 Oct 2023 11:52:41 -0700 (PDT)
Received: from google.com (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with ESMTPSA id z123-20020a626581000000b006b341144ad0sm1950069pfb.102.2023.10.20.11.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 11:52:40 -0700 (PDT)
Date:   Fri, 20 Oct 2023 11:52:34 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Stop zapping invalidated TDP MMU roots
 asynchronously
Message-ID: <ZTLMcmj-ycWhZuTX@google.com>
References: <20231019201138.2076865-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019201138.2076865-1-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-10-19 01:11 PM, Sean Christopherson wrote:
> [ Upstream commit 0df9dab891ff0d9b646d82e4fe038229e4c02451 ]
> 
> Stop zapping invalidate TDP MMU roots via work queue now that KVM
> preserves TDP MMU roots until they are explicitly invalidated.  Zapping
> roots asynchronously was effectively a workaround to avoid stalling a vCPU
> for an extended during if a vCPU unloaded a root, which at the time
> happened whenever the guest toggled CR0.WP (a frequent operation for some
> guest kernels).
> 
[...]
> 
> Reported-by: Pattara Teerapong <pteerapong@google.com>
> Cc: David Stevens <stevensd@google.com>
> Cc: Yiwei Zhang<zzyiwei@google.com>
> Cc: Paul Hsia <paulhsia@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-Id: <20230916003916.2545000-4-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: David Matlack <dmatlack@google.com>
Tested-by: David Matlack <dmatlack@google.com>

(Ran all KVM selftests and kvm-unit-tests with lockdep enabled.)
