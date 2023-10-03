Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0CB7B65B4
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 11:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbjJCJkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 05:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239685AbjJCJki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 05:40:38 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F3BAB;
        Tue,  3 Oct 2023 02:40:33 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-9adb9fa7200so146734466b.0;
        Tue, 03 Oct 2023 02:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696326032; x=1696930832; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7CyRh4kQaOdknBgWyMmgJve4C/+MYGcjkmbGU4vHGSk=;
        b=kAfxjOXRzPLD6U/MqWsJxEV75CpMQ2EeQL/sgjpAp7oXcijS2KRX0bxfNhjpn8YI3o
         DUcJ7hFQO3USCu1f4V+q3I3RHSDR1GozmzP6V+sa8Jyybz75Rv80ZwPx372bDPAYlgNS
         otvCQ8GBjGT+JDOdqYI/OjsGGK+80zjq0YKobOMREw204NwUwicLuorEWXm3ELjuxlNT
         kG8N355kzRXTUmegxjQhchAOfNGtcIXsify0tr0DOPeMv7TRSmzyAN/7jH9ddqI3zg7r
         BFogMdMAhSNvvHV+uz7nRvlM3fxc1RZjHQjcFuKqB3rNxU1ScjNHsTbhVDkGI1HAlbHz
         ueGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696326032; x=1696930832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7CyRh4kQaOdknBgWyMmgJve4C/+MYGcjkmbGU4vHGSk=;
        b=gF7BUGI+2bA/s6OR6bNsR+dF6jA2RMsarGpJVyITzwHKg09ln4EACcGu0+9DGKA0AH
         na8caODF3jEBQiKKliPQsypqBciM/nnC3ZyVKpeQZd9u9ZPNDEfAOv1VYH3C2OcKeEzR
         qW3i26XIO1Lsv15FwH8+Hw5C0Nz+f0Gtn15GMgIHvtEtsjhHKafQ6X5LnGq6iC3/Wnb/
         glIOF1ZBbZu+lsWNV4J66ay5wBPMltteOjDukmqzGUAJeEjPuXG+rPCxuohwyWTRvNh8
         fG0MpJfk30K9GUJ2/223HI0y+cPD/bGVkKX/RAbxOtkUF3ZKhcIfgg03xzjPWNGSFWhh
         J+0g==
X-Gm-Message-State: AOJu0Yyzo3Z1RcWuC1RrXBhBo+H8QTIwS6ADsFc5/zROAt9opDqVPX5N
        FsYTMCKycnxGZgrsEFREq8g=
X-Google-Smtp-Source: AGHT+IEn38FV2RHMM1HqKtteE6m3acfP4+wNwDoKg0nQehp6GxiyBRTrcI2FUoRcydg3Xdprf5qxBQ==
X-Received: by 2002:a17:906:6a10:b0:9ad:8641:e91b with SMTP id qw16-20020a1709066a1000b009ad8641e91bmr1730320ejc.11.1696326031915;
        Tue, 03 Oct 2023 02:40:31 -0700 (PDT)
Received: from gmail.com (1F2EF530.nat.pool.telekom.hu. [31.46.245.48])
        by smtp.gmail.com with ESMTPSA id h14-20020a170906590e00b00992b2c55c67sm760112ejq.156.2023.10.03.02.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 02:40:31 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Tue, 3 Oct 2023 11:40:29 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Jinank Jain <jinankjain@linux.microsoft.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jinankjain@microsoft.com,
        thomas.lendacky@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org,
        tiala@microsoft.com
Subject: Re: [PATCH] arch/x86: Set XSS while handling #VC intercept for CPUID
Message-ID: <ZRvhjd48oHq2gXB2@gmail.com>
References: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231003092835.18974-1-jinankjain@linux.microsoft.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


* Jinank Jain <jinankjain@linux.microsoft.com> wrote:

> According to [1], while handling the #VC intercept for CPUID leaf
> 0x0000_000D, we need to supply the value of XSS in the GHCB page. If
> this value is not provided then a spec compliant hypervisor can fail the
> GHCB request and kill the guest.
> 
> [1] https://www.amd.com/system/files/TechDocs/56421-guest-hypervisor-communication-block-standardization.pdf

URL doesn't seem to exist, I get redirected to AMD's 404 page.

Thanks,

	Ingo
