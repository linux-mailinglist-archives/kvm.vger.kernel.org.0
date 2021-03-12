Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA63339908
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 22:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235221AbhCLVWN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 16:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbhCLVWD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 16:22:03 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9B2C061761
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:22:02 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id t85so2703334pfc.13
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u8uyrgtbd9PGRfePe3rRDCTWMbYmxWtSWg0H3VHkObM=;
        b=UkNlmgi9rqD5m/wnaoUPOHBunw3rWK12wNn0DEuN7i3IglDv2RFxVs/cwvjvksS+vC
         9+hWZaAAfQ4mbo+QAgp69sVeQ7coqMOr+xbqWi/URqtKXC3AnkDmJgLBNoOMNEM6/BCL
         9OJtuiE+ZvWqS0BgUWeEdRRxmVGYpE8Uq+GNNo/O/oGDDsU5jj3FFMUvs0rxxvcvTp4T
         y1G85vW09NTHiPojS44NlNiQmbFaCYRR7nIuQDxX1vFudkyDQL7hZ9EvRj5b0neVtqWI
         mS7oYJt/DOPgW2Zc3+nJ9RUuiJtGg+qhL00fryQnj9QwSyd/cxpARoPMVXOXFCqADdFd
         Ua1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u8uyrgtbd9PGRfePe3rRDCTWMbYmxWtSWg0H3VHkObM=;
        b=PKrbI+iUPHVis5nOX7wuduiNAqfA59c/shQx1BKlLovF1CeBRgFyEWTPT0y6AYukC+
         jLi7Q4S/AZPWSrchqiyxUa0j/agIFGfu+c3XqD58lctIoVwnEtJlflV0p88yGjGJ1ogU
         qv9D39dumnNGPN1arAr/hqFKJ8VaQGHI7iZvOSMz5pdfES6xah0pE3or90/0kkqva2Ee
         +8f/mvHxhivGtK41QM/wGh3Od0ItKJdt4EjSLielulduXuZ7/zv77CSQveRO2OV+q6Yj
         x7jgul6IkVD+f+TS00GUTNx/C1uPGZfQ/vk+jpDCMQJV0G/cqXZW9QlHYQjzPW4ljCce
         4wrw==
X-Gm-Message-State: AOAM533u9B7ocDqofD5ByxdWhZXJyWFUsAXAo1exwwsI7MORIURoP3U3
        gEFqZ1BiSOXVLUWwAalKtSZ/nA==
X-Google-Smtp-Source: ABdhPJyxFWrKdyGKv6RmzV1VVMWiUb8JpfXwKBY27PwR6dQy3L1X7t02k4akXUsl4jPCHDsPWatC+A==
X-Received: by 2002:a63:fa02:: with SMTP id y2mr13327763pgh.412.1615584122019;
        Fri, 12 Mar 2021 13:22:02 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id m16sm6300380pgj.26.2021.03.12.13.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:22:01 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:21:54 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <YEvbcrTZyiUAxZAu@google.com>
References: <e1ca4131bc9f98cf50a1200efcf46080d6512fe7.1615250634.git.kai.huang@intel.com>
 <20210311020142.125722-1-kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311020142.125722-1-kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 11, 2021, Kai Huang wrote:
> From: Jarkko Sakkinen <jarkko@kernel.org>
> 
> EREMOVE takes a page and removes any association between that page and
> an enclave.  It must be run on a page before it can be added into
> another enclave.  Currently, EREMOVE is run as part of pages being freed
> into the SGX page allocator.  It is not expected to fail.
> 
> KVM does not track how guest pages are used, which means that SGX
> virtualization use of EREMOVE might fail.
> 
> Break out the EREMOVE call from the SGX page allocator.  This will allow
> the SGX virtualization code to use the allocator directly.  (SGX/KVM
> will also introduce a more permissive EREMOVE helper).
> 
> Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
> more specific that it is used to free EPC page assigned to one enclave.
> Print an error message when EREMOVE fails to explicitly call out EPC
> page is leaked, and requires machine reboot to get leaked pages back.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> Co-developed-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
> v2->v3:
> 
>  - Fixed bug during copy/paste which results in SECS page and va pages are not
>    correctly freed in sgx_encl_release() (sorry for the mistake).
>  - Added Jarkko's Acked-by.

That Acked-by should either be dropped or moved above Co-developed-by to make
checkpatch happy.

Reviewed-by: Sean Christopherson <seanjc@google.com>
