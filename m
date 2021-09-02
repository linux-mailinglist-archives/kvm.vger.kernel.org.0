Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 032AE3FEF81
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 16:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbhIBOg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 10:36:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345374AbhIBOg1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 10:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630593329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UXAhxJKeZF3J+7oqF+kPNby+2j1qsB6aw7GpNeUB5QM=;
        b=YHmzDzOVP8fZUk++6rCAUcJOsrlHsgE8XHs9GiokWRQiEULRuwRD4eaRaySs6IhmAaPr9c
        3K/NUgl7N743jZJr4wF9bLkYy3VoFtaneAilv42XWq2xhaeE2588K38iSFvTowox4GPGSn
        vuWoVwZATVMFR0igjrWc5Yhwgsj4OAo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-XU2OYQg0PVec_x4WWGwfwA-1; Thu, 02 Sep 2021 10:35:28 -0400
X-MC-Unique: XU2OYQg0PVec_x4WWGwfwA-1
Received: by mail-wr1-f69.google.com with SMTP id v6-20020adfe4c6000000b001574f9d8336so608718wrm.15
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 07:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXAhxJKeZF3J+7oqF+kPNby+2j1qsB6aw7GpNeUB5QM=;
        b=g2/E0KKY/LgpRRsqg4tClQWGOHEnNbI5h0FRPEdIgLYsv/Zit3wxIExJwgWGrxpDrc
         EYczppYGMJnXarvSAAwxJFOcBmq5iuIfSb91fU7EjOB46Ogiq9L2a1zQLX6JeFYvVAjK
         RLJttMONO+nB+ajrLRnir/OWJ6a54ch9jmS9+akgBzcQ5+ZIY47SzDIRe3Lm64+HpMot
         IecuuxrmpvMENk1cjAPbw2xllaV1PfkJ61VzKLE1F8Dz4d1jwE5+h5AwhRSIQ13F07UF
         upDReMr6TfPNbi3OWMoQnj74euMYT23bmm05DH+3B1KSl89iYJMv294ziNmcem9VcTME
         jfdw==
X-Gm-Message-State: AOAM531SNfOhGSjQ74bgCgAVMJ994fttFor/o1XJoG++HTzTox/mfAtk
        6IC4WpkTI4ggmBQbwtr4fimwK/ZJjW3yynJGbCQJxzsrsjR3aJPapfE/tuyA2RX+Cwg3HOLpGy3
        yq3pMGxyPqCAy
X-Received: by 2002:a05:600c:35d6:: with SMTP id r22mr3535274wmq.44.1630593327074;
        Thu, 02 Sep 2021 07:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9o3Br43dEQefXp6QdLiHjyMHkpP9VDy99DVBV7/iLzkKW8NQEuihUoh0UpylVyROp15dTRw==
X-Received: by 2002:a05:600c:35d6:: with SMTP id r22mr3535261wmq.44.1630593326922;
        Thu, 02 Sep 2021 07:35:26 -0700 (PDT)
Received: from gator (nat-pool-brq-u.redhat.com. [213.175.37.12])
        by smtp.gmail.com with ESMTPSA id l17sm2107112wrz.35.2021.09.02.07.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 07:35:26 -0700 (PDT)
Date:   Thu, 2 Sep 2021 16:35:24 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 05/12] KVM: arm64: selftests: Add basic support to
 generate delays
Message-ID: <20210902143524.h74zmunzjrtb3o2v@gator>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-6-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-6-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:05PM +0000, Raghavendra Rao Ananta wrote:
> Add udelay() support to generate a delay in the guest.
> 
> The routines are derived and simplified from kernel's
> arch/arm64/lib/delay.c.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  .../selftests/kvm/include/aarch64/delay.h     | 25 +++++++++++++++++++
>  1 file changed, 25 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/delay.h
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

