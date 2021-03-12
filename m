Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9B733991D
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 22:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbhCLVd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 16:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbhCLVdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 16:33:40 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF06C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:33:39 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id w34so15624042pga.8
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 13:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iVsxRcsawWsgdZYrcTYOb1n/2Sbbp73pya7fmqOzbMM=;
        b=iU0N0qMeYphwKiEy/0gaspa6VWKm+Nt69kIn87RoNKxVXvrAx5xTe9v5AzEAN28HA7
         YtKRHO05kwSsCPWGpTpqIWE+yljx5wsWZMMfePpFUKqDFK1aK35s/y3dWNP7OZ7ZCZVR
         0zMS3dzjgF/LijZi2YGejfpyGDSV74yVL59mb7BVQ8AD/EzLTxdkB1pU32QGNoNJ1t28
         HheevnlBsUSuT/xl8BNmCnFrt1FBOsBZzfa7c69ql6kTimL4Dd1eU6mw03rA42jgrqts
         Rk+GNZU77eHk7SlGMBw8oaHOlrroqEqRpGRkXTCZATJVsi3Jjcik4oEbnpRf0SWORfUA
         LoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iVsxRcsawWsgdZYrcTYOb1n/2Sbbp73pya7fmqOzbMM=;
        b=hM4xExNU1QUTBMOL9545WEQ/AICakk4ENoL6QEEfzOKEIXh2EKTsskXFwzSJG+NTHd
         tsS/8y/GAvIxPYzaedKH1e4FPepTNboy0xAZM13CTLX8oycjoz+qIqi7o+YLAHtIOIKm
         0nfa+CJnA3kjEjhr0LU+BdnbDeEQvuBbfTr2GsGPfeCqOHoU+Ecy5u3lt22zjgtVfMsg
         Shzmm9Ef3sZAorSd3AMQKPHTjiI7HJIX5UclbygUAg87uSoD0TbjpZZsxT+cv2fMn1In
         wx52QueKQ0Y7RodhkqZn+EX4vyEc5XJNlPrJlcUO4V83saNRtGkbmqgQQEyNN07VhXVG
         UIKA==
X-Gm-Message-State: AOAM532VLohjNyHikNikP+7OJJ+4HGYqmx2rWFG7kCOdbUP/TXQ8ShVo
        Uf4Z4pXOMsHv8FgH6hc09nsVG8rt9skZLw==
X-Google-Smtp-Source: ABdhPJyzFmLGS3OHDbNmbZP3xGaBaD+KZkN2wLIU/7KbnCgdx1a9fR5Dif0M2wDntXghS47+usszog==
X-Received: by 2002:a63:74d:: with SMTP id 74mr13471770pgh.316.1615584819001;
        Fri, 12 Mar 2021 13:33:39 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id i14sm3141527pjh.17.2021.03.12.13.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 13:33:38 -0800 (PST)
Date:   Fri, 12 Mar 2021 13:33:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de
Subject: Re: [PATCH v2 06/25] x86/cpu/intel: Allow SGX virtualization without
 Launch Control support
Message-ID: <YEveK42VVla8ibkl@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <f6d21cea6cd3b477a0e12c785feb0b6a2cfdde58.1615250634.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6d21cea6cd3b477a0e12c785feb0b6a2cfdde58.1615250634.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021, Kai Huang wrote:
> +	if (cpu_has(c, X86_FEATURE_SGX) && IS_ENABLED(CONFIG_X86_SGX)) {
> +		/*
> +		 * Separate out SGX driver enabling from KVM.  This allows KVM
> +		 * guests to use SGX even if the kernel SGX driver refuses to
> +		 * use it.  This happens if flexible Faunch Control is not

/Faunch/Launch

Clever handling of the multitude of combinations!
