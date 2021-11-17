Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B52454C70
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 18:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239624AbhKQRup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 12:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbhKQRum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 12:50:42 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EE1C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:47:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so2829672plf.3
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qwSTsWKREBd0j1OPxgShIGxpysANOcsMn/XRkTtpEHE=;
        b=F/j/ko2lWx+RLWuivdYMCWp8SCc94lKtTOBlvbRq9MU9ZxmZ4fr17+lqzPhFfE2zTs
         9LmZ8JDDiho3dgt1lwT0LRtseEqUCE0nNa2Wh2idE4y74SbgOnfwOqcbkNSdXykARnob
         diD0ZZs04Nydp98DDRfttmnQPlMrtUpcnzLMuD9dFzTQJ3hgbXU+QBXcqy/repz3Ki5a
         6DC8WAepwBICqmFRqGnpnk0D6ryApUtMBDjsZcNVJLPtqgNII95ibYGDH4GFrXg9r/ws
         ZpEJgrrVSLSjlhMuaJwXA5RHv8ekuldQ3gVpipQ2JO39Fu3STOuRS6hSRSXonts9OawM
         sfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qwSTsWKREBd0j1OPxgShIGxpysANOcsMn/XRkTtpEHE=;
        b=jf4AxFOf4wVnCk8NuzZcmjnIfx1htA760k7JzVIYrkAdpcUcbls3f1ddCUVCijkw4d
         UtbwVDoaTpqwSRt6/lweQkWI+lMt8S0SxSbgjDvbcntmt8tMRgOqiV2ywtzyNtyUn8Hq
         1HDhQxWXzMKgLSZki/NbEtFg7AixLfQ4A/0pumkGfD60yxHGI/EfNS6sfR/2eWlLSSZi
         jYop+IO6Rbljc3Z1UVI+m7HsTcOVKiEKV9WVP+nNNB9/v0CdR0NunSqqu08H8OYIRBCu
         WD4lxFxsXPw+sk4yEcL/mAnSLCAoERBS9/cK5XpjghDoWIe33fqpfJGVC+byVMRsv5HC
         o2/w==
X-Gm-Message-State: AOAM533O9lcwUDbpd80f7H+geMiv/aP9nuS1j7ML3HDSPS7NmBKayfLp
        MMDyFFsZbo0eb4gT+iktHsiyWKD2cDx6ING2lMBiPg==
X-Google-Smtp-Source: ABdhPJzbaDw8BTsyna8LfzocHNBbcTgEWn0dMfdtuOafOJTEG6dZIOm8878lO/uZDHmQDRsRtP1ZTi/L/syebrv9oPs=
X-Received: by 2002:a17:902:db07:b0:141:ea12:218b with SMTP id
 m7-20020a170902db0700b00141ea12218bmr58724450plx.46.1637171263009; Wed, 17
 Nov 2021 09:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20211117163809.1441845-1-pbonzini@redhat.com> <20211117163809.1441845-4-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-4-pbonzini@redhat.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 17 Nov 2021 10:47:32 -0700
Message-ID: <CAMkAt6o8HUBogtWmXVqzkeoXn9Tfb19yQnhUHb0Rp7bLjA6vkA@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 17, 2021 at 9:38 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Encapsulate the handling of the migration_in_progress flag for both VMs in
> two functions sev_lock_two_vms and sev_unlock_two_vms.  It does not matter
> if KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM locks the source struct kvm a bit
> earlier, and this change 1) keeps the cleanup chain of labels smaller 2)
> makes it possible for KVM_CAP_VM_COPY_ENC_CONTEXT_FROM to reuse the logic.
>
> Cc: Peter Gonda <pgonda@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Peter Gonda <pgonda@google.com>

I like the cleanup thanks Paolo.
