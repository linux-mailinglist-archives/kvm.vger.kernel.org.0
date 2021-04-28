Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3736D890
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 15:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239900AbhD1NsS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 09:48:18 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:44743 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239888AbhD1NsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:16 -0400
Received: by mail-wr1-f50.google.com with SMTP id h15so10888609wre.11;
        Wed, 28 Apr 2021 06:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iGL4C5pisQWePSYbT1yoPzAALGDCskG6Y8klDr3F6nM=;
        b=PmRSIZxDKcE8Th/T03mo9M+jroj+CMvtCwp8KOQclXwdRAe3yZpel91m5Nqgdznp8k
         n9JYbatuAeR0IOKTOKxkT+l2m+Qb7JhQbpQblQpKcLzYq0JfGuecMXOIxyJL251kDcFL
         DqGz90WaKftdHliRnDnAlpc0U3kmhGGeJNWih/QU1P3MJIhauQnNyA7g8SSMqaxcRA/9
         U44Ym30iibN9Pitdy8KVB9ioqgINpfXpwwzw+vHR1aPonDTsqFIKjT/APo6NgamaYLvO
         HkMeFIhSuvAzm1eMKaVEJXNw+YhyVKOFSiDOV/esfH8zFm1VjD8RMdg0ZqEYm/kiGNAJ
         UCRA==
X-Gm-Message-State: AOAM532Z4z0zqDnoktt61k5h2cKp3bv7sOb0ezLocyJUwqm2ESCnvYXM
        3WmUPfRgBWDD4L1WtmN3lls=
X-Google-Smtp-Source: ABdhPJw4Dkn+Z9URbKoQsbJhddTdNOfjqh5vsI4fkVhJPc8IJJJpiLV1ZYkAWFDulJlSfBchlrrv8g==
X-Received: by 2002:adf:de8b:: with SMTP id w11mr20658775wrl.315.1619617650238;
        Wed, 28 Apr 2021 06:47:30 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id u9sm3674051wmc.38.2021.04.28.06.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:29 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:47:28 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 2/7] hyperv: SVM enlightened TLB flush support flag
Message-ID: <20210428134728.jmu6bnjemhid3up7@liuwe-devbox-debian-v2>
References: <cover.1619556430.git.viremana@linux.microsoft.com>
 <cce3e52fde732ccdc7a34d2eb1e2d59917e4e5e0.1619556430.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce3e52fde732ccdc7a34d2eb1e2d59917e4e5e0.1619556430.git.viremana@linux.microsoft.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27, 2021 at 08:54:51PM +0000, Vineeth Pillai wrote:
> Bit 22 of HYPERV_CPUID_FEATURES.EDX is specific to SVM and specifies
> support for enlightened TLB flush. With this enlightenment enabled,
> ASID invalidations flushes only gva->hpa entries. To flush TLB entries
> derived from NPT, hypercalls should be used
> (HvFlushGuestPhysicalAddressSpace or HvFlushGuestPhysicalAddressList)
> 
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
