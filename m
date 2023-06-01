Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CB071F1A3
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 20:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjFASUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 14:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbjFASUU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 14:20:20 -0400
Received: from out-50.mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E84E42
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 11:19:59 -0700 (PDT)
Date:   Thu, 1 Jun 2023 18:19:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685643597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Op6GWryyUzDSh/WKepUl4rtfgY7HbqCToNhh/giYDNY=;
        b=dQ/1HkU/RBKu633RPJNBoIaUYkKuIykJ3jvYjangcBpqXZoGqUMYL1jddNS96KEhOTxkpT
        /4W/mUB/z7bYkpBBw9AkemuXQ4ypg54hb4NPUAzD/cLFVzQoMYmM0nMlm2FHVpyQhdnhf9
        aZU78Tk8cF5+eTpjBrgUnhm2hhD93BI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, seanjc@google.com,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 17/22] KVM: Introduce KVM_CAP_ABSENT_MAPPING_FAULT
 without implementation
Message-ID: <ZHjhSZFwEc+VfjGk@linux.dev>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-18-amoorthy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412213510.1220557-18-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anish,

On Wed, Apr 12, 2023 at 09:35:05PM +0000, Anish Moorthy wrote:
> +7.35 KVM_CAP_ABSENT_MAPPING_FAULT
> +---------------------------------
> +
> +:Architectures: None
> +:Returns: -EINVAL.
> +
> +The presence of this capability indicates that userspace may pass the
> +KVM_MEM_ABSENT_MAPPING_FAULT flag to KVM_SET_USER_MEMORY_REGION to cause KVM_RUN
> +to fail (-EFAULT) in response to page faults for which the userspace page tables
> +do not contain present mappings. Attempting to enable the capability directly
> +will fail.
> +
> +The range of guest physical memory causing the fault is advertised to userspace
> +through KVM_CAP_MEMORY_FAULT_INFO (if it is enabled).

Maybe third time is the charm. I *really* do not like the
interdependence between NOWAIT exits and the completely orthogonal
annotation of existing EFAULT exits.

How do we support a userspace that only cares about NOWAIT exits but
doesn't want other EFAULT exits to be annotated? It is very likely that
userspace will only know how to resolve NOWAIT exits anyway. Since we do
not provide a precise description of the conditions that caused an exit,
there's no way for userspace to differentiate between NOWAIT exits and
other exits it couldn't care less about.

NOWAIT exits w/o annotation (i.e. a 'bare' EFAULT) make even less sense
since userspace cannot even tell what address needs fixing at that
point.

This is why I had been suggesting we separate the two capabilities and
make annotated exits an unconditional property of NOWAIT exits. It
aligns with the practical use you're proposing for the series, and still
puts userspace in the drivers seat for other issues it may or may not
care about.

-- 
Thanks,
Oliver
