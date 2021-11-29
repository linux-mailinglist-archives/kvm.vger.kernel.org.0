Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682C64627D9
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 00:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236860AbhK2XL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 18:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhK2XLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 18:11:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C95C0698D8
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:31:16 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so16713187pjb.5
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 14:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9AvBVjsUrHA5ojRZLyc3LkomsSMZcJ46+mIK8nRuC78=;
        b=CjshS9PnnLSdv2AK/suTdsJ4choCpPz/1eqxVn8V5C64WtDEK+OxYTQtzf2KARNDYs
         COUtacor2im7nKgw9GQ3xfaFd0SrSZISdHKBGeAlonlWrKqPYbmrSfjoNR8ILpdMcTw0
         CVW49Qi4Q5EkUat8G30wzGWaufKxPT4Ho9eRItfqBN1waMkAOk/UBxrCpXSg03MQuf0m
         zbRQ0OmIHWSbba4lWZggFAGOxpNwdFACeHn+aNiIsFIpAh7bkLUNhtFU48WC+3IrTRf6
         EEvW+oTZ2uXDmjZG49BDYSKcNcOZoYYJBBO1AbEV9ZBGIFEb7NNyOnkNwWS54JLnGmz7
         9bcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9AvBVjsUrHA5ojRZLyc3LkomsSMZcJ46+mIK8nRuC78=;
        b=Af9PBwiYw07QuvH21+dcVvU4aPOIvS7t4GJHj2nneQ8qkHkUdlKP2brTrnRWvdcJ6d
         bbMbXQu042wfCmW/l0B2Z9IksNOr1757TID8zi99pHLbB/CMo6+9YUccHXOdQ7AMp/DN
         a3O9ap3dDeJDyxFeiXqasrh5qaiwxgvjETjGoZvb5AcnqD7kGFodC9ukvmpcCaPLTCxh
         qLC8vUPrsvqJ0i91U6/nQTbpuU0S3pDdW3MkFREZyncve3MjJeZX/sOMEdYb4+w+XsbK
         89YRI41jVMq28rEFSw4S+jCKCFffMfnq9SAbx4QsYXgasNmrvbZRaGoNOPf9bPVACC47
         Ceig==
X-Gm-Message-State: AOAM533AaCVwIEH6cOsY3C8joBR3lmMq/pHJPtWF+JWtKusO5EQLdMIs
        6V9C+oczyCPX7Fvp9qjs8kRUeA==
X-Google-Smtp-Source: ABdhPJzF7uWEEj8d7BByxoVl2ngezip9hrJFXj3YT6xDYrOeUi4flFODdMBcQJRImPXrl/BcTlaGKg==
X-Received: by 2002:a17:90b:4b48:: with SMTP id mi8mr1120100pjb.214.1638225076325;
        Mon, 29 Nov 2021 14:31:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c2sm19188610pfv.112.2021.11.29.14.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 14:31:15 -0800 (PST)
Date:   Mon, 29 Nov 2021 22:31:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pgonda@google.com
Subject: Re: [PATCH 11/12] KVM: SEV: do not take kvm->lock when destroying
Message-ID: <YaVUsB4qBdhBlL6O@google.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
 <20211123005036.2954379-12-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123005036.2954379-12-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Paolo Bonzini wrote:
> Taking the lock is useless since there are no other references,
> and there are already accesses (e.g. to sev->enc_context_owner)
> that do not take it.  So get rid of it.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
