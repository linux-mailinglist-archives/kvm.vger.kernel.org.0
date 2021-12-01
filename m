Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5531A464522
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 03:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346280AbhLAC5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 21:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhLAC5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 21:57:49 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BF8C061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:54:26 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n8so16536849plf.4
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9A/2leLJbfX1szhJ25c58spVdgO6jJrp/elHwnh4vrE=;
        b=VTbhgSBz76ZAXqAAU3pEKuxePf2WpS4uKDeng9BYo8lhswfDH4kfmy7bX/pAEFBujM
         O3bTwxtcihymXSv4Ogqrl0wLYKcKkCSY/30PSat8Wq2AKNU8ZWZ0dxrxbAoBzfzG3RMp
         x+2X3dZOHH9puPBDxLCLurBfrxvdMrsWSjYOVdAxIKySMasMSp89YARw6YAuYhS8GngA
         kIDGR4Ar6tbQ3a8M/+z15YkDXuGxOlsfgS1hXOpXrfD8rH7EwM4nHX+CNBUNQhWozLtk
         MGujAmwkd4p5SczfwQHoFIh4Ok+n5nx6U2qS22x2jiak/dbhwT0XOs9xmvv4Hj6Zi26Q
         IpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9A/2leLJbfX1szhJ25c58spVdgO6jJrp/elHwnh4vrE=;
        b=btuKEM/TmCxmRsKjziICvu2qa1I0uUVSnUCp42nM4KuoxiiiNXWy8DJs2KKfO18ez3
         PsbI2kPHzhIeISriCrt9Aw8kuwmQVpSB3MCql5+Zpp6w4LMgDGyz2BjhrzslnKVhGcAB
         iEQy41xq94Unrl+5FAf6EJwMP+C21u5AQdpuT9Z0rMREslOgr0aURyL1CtD6+S4IgCkm
         h06zcnS15/Yws2U+QLMyAKI6bJPKjKyzNrGPSqdrw2e+gYCAqzg1SdCNc6hvrIUB4T8l
         k6HXR7WTZ5C33C0/Gn/4CW/QLbwsKkINbuW0DePxNElKWspnKplyWVf8tFJDAMGF67gp
         0/Zg==
X-Gm-Message-State: AOAM531rHrjSUQHDs/tf3yrJjozN+Ivwvf+56XnBuSVDc9FmtDRsgigi
        9FO5epaBIyQNVz+3KJYI02xAyQ==
X-Google-Smtp-Source: ABdhPJxOWDatsECgGBcAHEz6kwu67DVfRq3IjArlD9yguLiB64YzJv0E9qqzu0XJXLd6QlRALQ0Hrw==
X-Received: by 2002:a17:90b:390c:: with SMTP id ob12mr3830664pjb.212.1638327265405;
        Tue, 30 Nov 2021 18:54:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k8sm14530597pfc.197.2021.11.30.18.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:54:24 -0800 (PST)
Date:   Wed, 1 Dec 2021 02:54:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 21/29] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <Yabj3Qr8e85qhSg3@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a6b62e0bdba2a82bbc31dcad3c8525ccc5ff0bff.1638304316.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b62e0bdba2a82bbc31dcad3c8525ccc5ff0bff.1638304316.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> Memslot ID to the corresponding memslot mappings are currently kept as
> indices in static id_to_index array.
> The size of this array depends on the maximum allowed memslot count
> (regardless of the number of memslots actually in use).
> 
> This has become especially problematic recently, when memslot count cap was
> removed, so the maximum count is now full 32k memslots - the maximum
> allowed by the current KVM API.
> 
> Keeping these IDs in a hash table (instead of an array) avoids this
> problem.
> 
> Resolving a memslot ID to the actual memslot (instead of its index) will
> also enable transitioning away from an array-based implementation of the
> whole memslots structure in a later commit.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Nit, your SoB should come last since you were the last person to handle the patch.
