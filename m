Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E484E470949
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 19:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245569AbhLJSv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 13:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239970AbhLJSv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 13:51:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C7CC0617A2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 10:47:54 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so10049829pjb.5
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 10:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GyaACeIn1zHgdYM7z8mS8IaPWMZDmqmxLUP6F95LAKA=;
        b=CjH+rCj8mSr06hi9M0gnLzJIT+jKsl4JT/kvG/OMkg4866TpCO6+61HmPnY9uUDNKz
         FnQ4w37iTKLtmwpesp6DF6m1F/fGCxGNnsETzi0ayJu8WXv3ly4jU9r4BS/CnQVMT51+
         OVyauFyiRUQn49rxdixIfAYPSHRE50M7t4kT3oF+OIJtJJvz6nn48Dz3sEm3Q09oOS4I
         PmeLPRr23EId+amvGzc2/L2y9H9OUXj3SLRXUfX32VhR/4b3+AF88/KONwOG00bZ2TQy
         ddK9/AQGF17Vx0KT6//9R7R7snn4CA7EhkrW+AOxsd2zXtVQrk8rxoyL8etjlAo+o97z
         967Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GyaACeIn1zHgdYM7z8mS8IaPWMZDmqmxLUP6F95LAKA=;
        b=KdVyrHxOIi7Q66QG1uf2RSmFNwT/fchGOzx3Recj3oD6rkETRg8BEL3vGK6KpWy27E
         om5rkA4E1nswMb6pUb2LNkDYDr533EsLIyK59RfGdHc422fSB/CUqNcq933BFSKWiYdh
         /C6mLBhbjg6gyUL3RwrhMFi20iU3cnnM2SqjQ91EQf5zcUojpy96SZLUXVlvLUyKmk2l
         4SqpCMke96YmwVr6HANfFPWRL91up8RPil1nPGKaRztKsBwi29zJgx22NXkg4GdGjsGF
         M0DeqBkV5U+8SNHOY7sgSNFN11WQJ5pb2+NQw+3SNgKOcvGAuMZk7si6JpbXIRnw5gZ+
         EHNg==
X-Gm-Message-State: AOAM53251+S8TofDFtijbb5b7fhzlmS6tiUSWDyPrh4EsKujbxse+8uM
        pUaP4Ms8/EzBXqujKxUw59jr1g==
X-Google-Smtp-Source: ABdhPJyCkJokL13OsnW0WLcal3B7q1mNpiw7H2/eMTumY02cc5bJrSRojPkBawVWCgSribIWaJ0Hcg==
X-Received: by 2002:a17:90b:180d:: with SMTP id lw13mr26139747pjb.225.1639162073474;
        Fri, 10 Dec 2021 10:47:53 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h1sm4044766pfi.217.2021.12.10.10.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 10:47:52 -0800 (PST)
Date:   Fri, 10 Dec 2021 18:47:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     cgel.zte@gmail.com
Cc:     pbonzini@redhat.com, shuah@kernel.org, vkuznets@redhat.com,
        ricarkol@google.com, maz@kernel.org, aaronlewis@google.com,
        like.xu@linux.intel.com, dmatlack@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: Re: [PATCH kvm-next] selftests/kvm: remove unneeded variable
Message-ID: <YbOg1W7DP0XOkOkm@google.com>
References: <20211210022755.424428-1-chi.minghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210022755.424428-1-chi.minghao@zte.com.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, cgel.zte@gmail.com wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Return status directly from function called.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
