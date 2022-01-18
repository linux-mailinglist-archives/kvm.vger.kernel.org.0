Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA718492841
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 15:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbiAROW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 09:22:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244543AbiAROW1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 09:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642515746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y4YzeEHCT5Qsp1fTF2Ff1Fo1X3wdgn1gp47dQ5F5Huc=;
        b=Gcj7TMGEHboZaCr6rlwiPf7SSMLa3Pw/RL/BnC5t06ONDehofRcZ+waOV/7V6FQh+9EA7e
        P1O3T/XRj23f+m7ZmnYpWrJvHhNUODi1ivHFO0pNkIr/DBQnFE5Tf1MSkAL9u2q5950zva
        l2bUiynzSFsOvizov5mzylY/DtNyYNM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-k6mEmK25NHCosLUsBQDnBg-1; Tue, 18 Jan 2022 09:22:25 -0500
X-MC-Unique: k6mEmK25NHCosLUsBQDnBg-1
Received: by mail-ed1-f71.google.com with SMTP id ee53-20020a056402293500b004022f34edcbso6450703edb.11
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 06:22:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=y4YzeEHCT5Qsp1fTF2Ff1Fo1X3wdgn1gp47dQ5F5Huc=;
        b=TOQoOribVR00BqnVxKJwStGxNeIN7ru0MlDzxg9Kx9SHbdVTCFev8WbNt/qZVPsyIz
         OS079Vy9Xfl53gA7FtGUz5aHpu2AtExwMLlpnOWZZjLDokfMoHcE3cLwJ4LMCqxcxMIa
         yB3T7RvhJZrSKlUe+zDJtpSmh27vyOdCO9RrSNXmsXBDKR22hRAJj/2eEuVtBora44Ke
         AfVsDnM5g10rbWnc68+RAKt7M+PDEVMvJGxUrTnvyypN0suxRuKSLSCnD0PmM8omncBU
         81bU6pHd9B1MtikUmQUOzcRXMcjz2h7ijq+M0rcxelduWo+GzjoX+hkugc3w5/JJprIn
         zfqg==
X-Gm-Message-State: AOAM533ykcFhKDtjk/QOkJzRPzD1HQcFiEP4W5gunEUzJ4sQza0xlbMS
        hF3PJYb64Hn6Q3IiODMW3fOYQP8OTqj5RMpcLUH0VQB+aWmMmsoAMSCC2r1v/1kbRv4c98+ux0B
        LJVHy1ZtJ7D+w/0ZGHp4LDRSZbJKOkYFzwZytH2uC8pZbVAAOWhZrbQIG+kWC7vL+
X-Received: by 2002:a17:907:a088:: with SMTP id hu8mr8326075ejc.371.1642515744078;
        Tue, 18 Jan 2022 06:22:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwzJQAqutfAisYqiCh+L8bg9o17eCN/WQ/E0+eI30kykTX1fCzEW1NnfAmieqKaAxTUw7qCtA==
X-Received: by 2002:a17:907:a088:: with SMTP id hu8mr8326054ejc.371.1642515743776;
        Tue, 18 Jan 2022 06:22:23 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l25sm4381770edc.20.2022.01.18.06.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 06:22:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/5] KVM: nVMX: Fix Windows 11 + WSL2 + Enlightened VMCS
In-Reply-To: <20220112170134.1904308-1-vkuznets@redhat.com>
References: <20220112170134.1904308-1-vkuznets@redhat.com>
Date:   Tue, 18 Jan 2022 15:22:22 +0100
Message-ID: <87k0exktsx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

> Changes since v2 [Sean]:
> - Tweak a comment in PATCH5.
> - Add Reviewed-by: tags to PATCHes 3 and 5.
>
> Original description:
>
> Windows 11 with enabled Hyper-V role doesn't boot on KVM when Enlightened
> VMCS interface is provided to it. The observed behavior doesn't conform to
> Hyper-V TLFS. In particular, I'm observing 'VMREAD' instructions trying to
> access field 0x4404 ("VM-exit interruption information"). TLFS, however, is
> very clear this should not be happening:
>
> "Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is
> unsupported and can result in unexpected behavior."
>
> Microsoft confirms this is a bug in Hyper-V which is supposed to get fixed
> eventually. For the time being, implement a workaround in KVM allowing 
> VMREAD instructions to read from the currently loaded Enlightened VMCS.
>
> Patches 1-2 are unrelated fixes to VMX feature MSR filtering when eVMCS is
> enabled. Patches 3 and 4 are preparatory changes, patch 5 implements the
> workaround.
>

Paolo,

would it be possible to pick this up for 5.17? Technically, this is a
"fix", even if the bug itself is not in KVM)

-- 
Vitaly

