Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7CD85A6F67
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 23:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiH3Vpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 17:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiH3VpN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 17:45:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735A023BDD
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:45:07 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h13-20020a17090a648d00b001fdb9003787so7831354pjj.4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 14:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=44VnXLLnHKtAgGFhSbtPMbzo9iAnduWZIlZnH6SNdZI=;
        b=ER25Kx378MIYDIWcfjVSJPHZ7g+/wvXUWmKbsdcGwiHGnbYevzRc4sbZNhSDonjo1o
         Uis0BW4YY+OG0RGyIz789mTWtC64CfQ6OMUB9j1kODu2eprcvsdOaXBj8Fc2GLlAsdqM
         uZT2NSG5Mld5NFxTC86BHzY7SC94Md6NpAfM21kYOvjzao8fJbgaDCIPKdBseMflGgK9
         XfOtKVP73PUaSdQ309OT1Bx2qpmu4H+e3159qSnotCVl0o8KS0a2EduCkQYzDsM7+4Jk
         cvi8/gweXSU0wL8nR7o9EiQzyEB48uxfhch34SOb7dXIRBbptw/a3yJxxpIXPbo6xyHH
         InTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=44VnXLLnHKtAgGFhSbtPMbzo9iAnduWZIlZnH6SNdZI=;
        b=0ILoCjvILBgkzTLlHhFyBHcGG7sNUAykLmJYEdr97OXVDX0DSmAqg6LI0Vl3R4c9ei
         1mfSTiverwGXG7V4hfFNrk4ilWLngSAJkXVZhFLafMGotN1EX3EVQgyDgwWdl1t+YF0Z
         6cMLwlSB4MG3kJAZMcd7tlFdnCS990RO2iQnhBLe5UubcznkWefKkM+ojHOf4unTid6Q
         7joSCUTqfU6Dx++4vqyz5DIqldz6d95BSd8eA499xHMkYpNPCVmLiNb8rqS3qiJ3/JBn
         R0lD3n8eyDeQGQHT4xEAzB7nCIvNmJdVz9V773Cz6VDnlZYrO36yRgNrm2fWH40cr3hk
         mS5Q==
X-Gm-Message-State: ACgBeo2/Sqd3mi2DGHc/FGGs+PyCx+4A/12q+Mp2bpzcXNl8S+u02Dal
        JlLznu4dJWXmut1U43FEEZtC/w==
X-Google-Smtp-Source: AA6agR5/W1DK4H9PA/IRXXyFIzU8NvKMWBxoyIR50AoZ3YoUUQjt2TpMYEuOeXWyKoHlEJAsCxsC2Q==
X-Received: by 2002:a17:902:e742:b0:172:fdcc:a549 with SMTP id p2-20020a170902e74200b00172fdcca549mr23316366plf.104.1661895906468;
        Tue, 30 Aug 2022 14:45:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709027e8e00b00172f0184b54sm10098789pla.156.2022.08.30.14.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:45:06 -0700 (PDT)
Date:   Tue, 30 Aug 2022 21:45:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Junaid Shahid <junaids@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dmatlack@google.com,
        jmattson@google.com
Subject: Re: [PATCH v2] kvm: x86: Do proper cleanup if kvm_x86_ops->vm_init()
 fails
Message-ID: <Yw6E3u/6ebjaupGB@google.com>
References: <20220729224329.323378-1-junaids@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729224329.323378-1-junaids@google.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 29, 2022, Junaid Shahid wrote:
> If vm_init() fails [which can happen, for instance, if a memory
> allocation fails during avic_vm_init()], we need to cleanup some
> state in order to avoid resource leaks.
> 
> Signed-off-by: Junaid Shahid <junaids@google.com>
> ---

Pushed to branch `for_paolo/6.1` at:

    https://github.com/sean-jc/linux.git

Unless you hear otherwise, it will make its way to kvm/queue "soon".

Note, the commit IDs are not guaranteed to be stable.
