Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485B4E05DF
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 16:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbfJVOE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 10:04:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58506 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389075AbfJVOEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 10:04:25 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1E6F81F18
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 14:04:25 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id z9so73206wrq.11
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 07:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3vKquIIhS417Xcv3ef04W52oBIikgSSCS3LfBkCoIDs=;
        b=LRu6OusB8FKXoRniJwNpH2Zj13CcR8LZrIAAELdlWX6tseiYXs2d47BRZ45tye3dH/
         rcFFVGZYk4jBhWsTbyhQbxbjBGpdXOsmmbFtMxvo2r0OKJxxUbj9c5PoDbPPwalXYX8X
         xR3usm095GO8hARfGrnxvMqJjTjQf8h+gyzmb37wlxwpJTaCFluwQmU97tS+XEkhC54L
         92NuUBH5Qm5MgfyJqw0YkMSpDCFX7btid/tVGQ1+FDvfP9/IJe5XcsSZM9onHyI9dsW7
         Bke6kxBcfZGfFXGXd8vYKwwYLXZlzgvcFliShS65xDtf5b/Zxq1zz7PuSYu9rtBmCz0T
         s2Sw==
X-Gm-Message-State: APjAAAVwGe7y3o0M4GkE1WR+nweDHBjVURNcXfNItPRIyfZugMFOsCOp
        MgN2cHgiPINwworXvku2P6Gz7C60Z/jZ4BIjx0MiSRQvzi2e9L9tRn/0wJMxrAj5Ws0okgYSiqm
        bcaxsDSpJOrg/
X-Received: by 2002:a7b:c049:: with SMTP id u9mr3176826wmc.12.1571753064239;
        Tue, 22 Oct 2019 07:04:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxd12WGZ28CK/g1W21d1r/6V7p9tDfXwdcdM4EXY3TusWKTyDA7mRoL7a/JX5NzrrGKErwrww==
X-Received: by 2002:a7b:c049:: with SMTP id u9mr3176775wmc.12.1571753063926;
        Tue, 22 Oct 2019 07:04:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c0e4:dcf4:b543:ce19? ([2001:b07:6468:f312:c0e4:dcf4:b543:ce19])
        by smtp.gmail.com with ESMTPSA id n11sm903226wmd.26.2019.10.22.07.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 07:04:23 -0700 (PDT)
Subject: Re: [PATCH v2 15/15] KVM: Dynamically size memslot array based on
 number of used slots
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
References: <20191022003537.13013-1-sean.j.christopherson@intel.com>
 <20191022003537.13013-16-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2609aedc-4fc9-ab92-8877-55c64cf19165@redhat.com>
Date:   Tue, 22 Oct 2019 16:04:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022003537.13013-16-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/10/19 02:35, Sean Christopherson wrote:
> +	struct kvm_memory_slot memslots[];
> +	/*
> +	 * WARNING: 'memslots' is dynamically-sized.  It *MUST* be at the end.
> +	 */

Isn't that obvious from the flexible array member?

Paolo
