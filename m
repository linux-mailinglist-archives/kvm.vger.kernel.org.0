Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 325072DD69
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 14:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfE2MsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 08:48:02 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39614 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfE2MsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 08:48:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id e24so3602277edq.6
        for <kvm@vger.kernel.org>; Wed, 29 May 2019 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MONbMDhNRBTOrhsT93yPHwMAxRk5gJkctOPhsHPlMjo=;
        b=pvzGmqfndke61sBQlh1oho21KJ6Iybo1zHRk74CTMX5dILmjLpgpFD9xiNkJcIkykj
         88K6WVvQaUnOZAxTaXUwsfom9gc9tKGhAlt9jDh1AvRVL2fcPUPvVciXyd+4/cfnzi6Y
         BQc+Kf6NRRPU+LUsTWAkOih+0iPrKPi5AV8QW2IPC15kto3MI2CcTIDgyW1NvpvnbaHn
         72gRT4fZtCzDKYazAwoauPiUnTinRIP0Jz8q0vmBhjkSQvKq344X6obRR8SDoPT0HYGL
         IzumjrtY2Gd+o3l7MaUv/iBxsDD93S/NUHjHNBVVcbESUuNn/24MBGAgjnldGThCL3xB
         SLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MONbMDhNRBTOrhsT93yPHwMAxRk5gJkctOPhsHPlMjo=;
        b=hvkGWBmxeLnFbgEVfBy4MmGCGFUmdNUzOAR83F2PHGxxAt1mD0STjca1AnfPqKXCjf
         xPbaCy6ds79+vFmTQVmxPRk8c6d7dWKzxkFevM3pU737WiKUCsaYm52nXdzcFCNyZBrr
         s5f1oUoU1BhwY6/JiiDmGQtoVgSPqQcq3yRF1OwzkuUPkMQ0WVufyfDdyLdkVaxeS7Tg
         3hGN2xAdMzPf4/HwxoDbRHoUL8LYPw9vBRhZkqZomXnHhFPCVfxhpp7F576RkMUOJ4ux
         8oQ212OVV5b5ibtViFT3gYkrlAke0QQAMk674MBTwqlN+oMpk5pdLfcbJByFQDRXhlSz
         gThw==
X-Gm-Message-State: APjAAAWz1ib7mF6+VzIFFBSA3WBga3DAaNC05Fj+GeeEVh7FVrf0EEeY
        4JUrdpBWUqxiC1OpNgiudlmz3g==
X-Google-Smtp-Source: APXvYqzoaFmZ7mZVbDTqlrFuJBSNrSbiSO0d9+zexx5kswJ+G5IjO7KLQ5NjC4EQdadEnFovCFgWeA==
X-Received: by 2002:a50:86e5:: with SMTP id 34mr136814479edu.290.1559134080713;
        Wed, 29 May 2019 05:48:00 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id qq13sm2797939ejb.1.2019.05.29.05.47.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 05:47:59 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 050E01041E8; Wed, 29 May 2019 15:47:59 +0300 (+03)
Date:   Wed, 29 May 2019 15:47:58 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Howells <dhowells@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai Huang <kai.huang@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        linux-mm@kvack.org, kvm@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC 05/62] mm/page_alloc: Handle allocation for
 encrypted memory
Message-ID: <20190529124758.ojyakxdx2zf6nmtt@box>
References: <20190508144422.13171-1-kirill.shutemov@linux.intel.com>
 <20190508144422.13171-6-kirill.shutemov@linux.intel.com>
 <20190529072124.GC3656@rapoport-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529072124.GC3656@rapoport-lnx>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 29, 2019 at 10:21:25AM +0300, Mike Rapoport wrote:
> Shouldn't it be EXPORT_SYMBOL?

We don't have callers outside core-mm at the moment.

I'll add kerneldoc in the next submission.

-- 
 Kirill A. Shutemov
