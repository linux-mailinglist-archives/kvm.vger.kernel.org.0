Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F486434DD0
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 16:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhJTOc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 10:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhJTOcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 10:32:18 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378ACC0613E5
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 07:29:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id w17so4423634plg.9
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 07:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XgjWa6urh+2o4wqBD5gUfgDpjgp0SCvskomJgQmYY+0=;
        b=ZSDO6CpOBnedFZe6DFUgjtyUK1MuJ5eE1NN4ZS0TVOkGRHpWKc2a4d/GJ5GoCygH4B
         G19Wh+vwFfSvS/Dii+2/P7ebLqIlqTayyCTdyRcVKKqmuTYIM/1lJEcUIfhbrc4JMm6g
         ZBEvoiE2wfWFJx8AM7EIqyLsFpjHUdsuo8VOjM4mUblUjA129GKFOSWt+3yXmjCBCOCv
         ycPzv2wPbaTsvljugga8WJunvimLGcrD2+1SSxHQoaTJbs2FMtND4ZiyvczkY2SlipVT
         Nra68u2y9R+snfbsjk2avm5dW4b6Xy/JS73pj+ibqtdqHmsgJHUrX5IIBMz/NlxiPQAZ
         yYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XgjWa6urh+2o4wqBD5gUfgDpjgp0SCvskomJgQmYY+0=;
        b=2TwbK5euch8CP8m8ffO7Kj7mA9wvlt2zqFdzHqyWbqyP1f5RnyuUJ9b78yR/2GM7VA
         1GjmccbhkAlxoWxQskpmpkl+h+KaoWtJiF5vQNq5DX9prfRljqmyfiDTtRPM9FAIYAot
         exYHwxANuPiTx4KmXAW5Srlz29+xKAVCH3aRbKoJJ8XWdHGhvdeLAqIUdDcNsRju0pS3
         tnPFCyMfhgHAFw8AMc7RslqxxA2zgM4cV8H86zxqrMja9P6sPBKmyUqbL0CwLW+mAdJC
         kP3xLp1PFrrkaHgywWSSABwcP8ZkmzWn0WjwkLuPdNDIU18RzEVtVT6NV9Af8YVUqTJs
         EFKA==
X-Gm-Message-State: AOAM532DgCu6w5Hj3W38KEwYHs3laEXhA4sxZhYH8d2tt9lljifs6Oyi
        hYBTcqbd+PFIWPDG7gqE9VDQTYy77bnjKQ==
X-Google-Smtp-Source: ABdhPJydu28OpbVkEA/WfwFuZQ8SyRqvPuLD1RDzpFZLwQNLnS7QNg/iWP42bkocOYE/dddoEWSm2Q==
X-Received: by 2002:a17:90a:2a0d:: with SMTP id i13mr284267pjd.166.1634740169636;
        Wed, 20 Oct 2021 07:29:29 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i2sm2774356pjt.21.2021.10.20.07.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 07:29:29 -0700 (PDT)
Date:   Wed, 20 Oct 2021 14:29:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v5 3/6] KVM: SVM: Move kvm_emulate_ap_reset_hold() to AMD
 specific code
Message-ID: <YXAnxXVxFrS41/ui@google.com>
References: <20211020124416.24523-1-joro@8bytes.org>
 <20211020124416.24523-4-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020124416.24523-4-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 20, 2021, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The function is only used by the kvm-amd module. Move it to the AMD
> specific part of the code and name it sev_emulate_ap_reset_hold().
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
