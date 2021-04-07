Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F43035772F
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 23:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhDGVxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 17:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhDGVxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 17:53:07 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E35C061761
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 14:52:55 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x26so346790pfn.0
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 14:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gjI6ZEfbZgwNYw/ZVoTIk/g0t8L7iO2fU8E3vcLBJC0=;
        b=fykLZS0x3gL8JhSj44N9LDU2kAzBbb6oQChBH6xGwaeHV5umyDspjG8fB+e/gTkRVr
         ZV1NiXf0npmMX2EVKNTlQyJjEkuea+mLE1TQ0dWElRRdoJD7KPJOP7oGgjvdSHqEzyj0
         /xUewgbDbijvjbWONXx45iVjBfeutKEx4hgJOLKi+0M8lxrfxn4QN5B6n4Q2VkAQHBqy
         hplc+bK5zDh71ab2/chnm7J5zEpdl7hWhu0OmmRuM9P327QUmkdypwsCmOAvQu1BrZ+Z
         KBlFjEFINzk3fGSnP+aXSmLaijWjaWsmn9RYD3y+hsvQlv21itFkVduZKPx++hCStaZe
         U6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gjI6ZEfbZgwNYw/ZVoTIk/g0t8L7iO2fU8E3vcLBJC0=;
        b=Bffw/przrZkjFunCAJXkbUjizzrIPt3G8Q8jeAToilYbxO3NB5UhoExvTCm9NPkkHN
         /jOX+SUy+du93K02bfgUc7YI+i2LIs58PFNCKQ1IQgNZEKOViHnbzOGtHhISY2DegiLI
         //2BWH2/c0b1MNPqqEWhhQPimCE2DQp4DvB0yWfSsyFAGTuWNDXU7ZJ3dMLjH/5Z/rSd
         tu5YsT3CU6140vPayH5U6YRusx8nAIaJPwUyeTuPXAxL24wq+k4iugbN97S0J6cr9gwJ
         iJSilLY7XKdOhH0ZP5ZKErYZF+fL1QvBcHFXp/i6LQ79s7BPuMNT0ORmkxMq6KTKXrm2
         LiZA==
X-Gm-Message-State: AOAM533zDlec3Urg/hdtl5cPChyNMYfeCuWCqdJNhbl2NtTUkxoIlUV9
        1Ih44leOuRnk1dfsuSBbAdPigw==
X-Google-Smtp-Source: ABdhPJyKsos4AvFJOXIkn+8qiDl1qTc/iuFrUlulvdS1NMsu7qpXf61Pf/ybPApKgjgwigKGwjTZmQ==
X-Received: by 2002:a63:cf45:: with SMTP id b5mr5055144pgj.372.1617832375043;
        Wed, 07 Apr 2021 14:52:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h7sm22679984pfo.45.2021.04.07.14.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 14:52:54 -0700 (PDT)
Date:   Wed, 7 Apr 2021 21:52:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 07/11] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Message-ID: <YG4pslLOybyOIDTC@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
 <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963a2416333290e23773260d824a9e038aed5a53.1617825858.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021, Kai Huang wrote:
> +	/*
> +	 * Copy contents into kernel memory to prevent TOCTOU attack. E.g. the
> +	 * guest could do ECREATE w/ SECS.SGX_ATTR_PROVISIONKEY=0, and
> +	 * simultaneously set SGX_ATTR_PROVISIONKEY to bypass the check to
> +	 * enforce restriction of access to the PROVISIONKEY.
> +	 */
> +	contents = (struct sgx_secs *)__get_free_page(GFP_KERNEL);

This should use GFP_KERNEL_ACCOUNT.
