Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E729E672DBA
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 01:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjASAyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 19:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjASAyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 19:54:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8173689F2
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 16:53:44 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id c6so829510pls.4
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 16:53:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JxtP2JZYn15BaZI+3hGbjmjCOphbX1iS/a9OgxH9eC8=;
        b=nYkvUuCvwNRmZ6/tYbIyRxA0D5d0Q0xjH60buaSFodXtojlR2kkCGcwp/4LFFLDF5X
         I1RnsHS5SYp8plDzHyEf5LU/X6DKkhRn2S2Lyz3XmsqH+daSlySqCxw40602Vm3iD0nT
         DePSkF6WyKct8hovGfr7ErVny4ZA7ijXnwQJ21ihuJ52HDHmdahaf5yxQmwKNVSPyUUx
         kEejswki3qDBbgIAfvP4BKYf8zP1xQwQy73uH1OgaVTdpT/ngUcOmbcwtwjO0/W2QTNf
         S+Os0Z0KKLxg9O+Xu6+bPXXQzawhp6Et8aYU1CRxWqrG5Xv58LHO6c1htrZJUo1A0Hc8
         1Sbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JxtP2JZYn15BaZI+3hGbjmjCOphbX1iS/a9OgxH9eC8=;
        b=4i33AbMgBgSt6dCpwmJBqmY/c3tc8l6U2eT9p/Z818iPSIeJR47Oim/devtfS4Gaxp
         4Kx8KN6xE8hX3HLG+TiBGCm9YXjx6IWMOZWxbY/v/bJ4r2lwLqGuWzUJmvcigaIc0CS5
         QeAxf1oDXHR+0k2XEet+DoYjBJ72iFiXQ4YPd/sVp8QjEOOkunbjw0Gb5ClCp85ykvBy
         lcUkmT50wPHVziYkOcz0WlJ8T1j1my7ckQIGst9bMlbCGcwLufNSRyvrozInzQEtVCyr
         ZgB8N9sTGHLXzyS1EP9/haDuz4ErtSa+0M5hCBYo/eqkmZHIjBWB2JBxGPmwxoevnQu0
         a35A==
X-Gm-Message-State: AFqh2krVhwzja3zH8+C3671wqkzPChfjsIxW4oTOE7fKB96218GgoxjO
        xx6qAYJRSDVsALAcryUG6FyM4keMCrwH+Vxl
X-Google-Smtp-Source: AMrXdXs4AR/eypC+8FwZqFfBXNZ5jiZW908O2b1D/lZ+STRLmhTSWLLV3FUCGHL/M576AJH/g+uREw==
X-Received: by 2002:a17:902:d409:b0:189:6624:58c0 with SMTP id b9-20020a170902d40900b00189662458c0mr2800450ple.3.1674089623401;
        Wed, 18 Jan 2023 16:53:43 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m4-20020a170902bb8400b00192a8b35fa3sm23704483pls.122.2023.01.18.16.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 16:53:40 -0800 (PST)
Date:   Thu, 19 Jan 2023 00:53:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        catalin.marinas@arm.com, will@kernel.org, paul@xen.org
Subject: Re: [PATCH v5] KVM: MMU: Make the definition of 'INVALID_GPA' common
Message-ID: <Y8iUkMbNM8jWE4RR@google.com>
References: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105130127.866171-1-yu.c.zhang@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023, Yu Zhang wrote:
> KVM already has a 'GPA_INVALID' defined as (~(gpa_t)0) in kvm_types.h,
> and it is used by ARM code. We do not need another definition of
> 'INVALID_GPA' for X86 specifically.
> 
> Instead of using the common 'GPA_INVALID' for X86, replace it with
> 'INVALID_GPA', and change the users of 'GPA_INVALID' so that the diff
> can be smaller. Also because the name 'INVALID_GPA' tells the user we
> are using an invalid GPA, while the name 'GPA_INVALID' is emphasizing
> the GPA is an invalid one.
> 
> No functional change intended.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Reviewed-by: Paul Durrant <paul@xen.org>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---

Marc and/or Oliver,

Do you want to grab this since most of the changes are to arm64?  I'll happily
take it through x86, but generating a conflict in arm64 seems infinitely more likely.
