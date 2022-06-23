Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4B1557C9F
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 15:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiFWNMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 09:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiFWNMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 09:12:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065B62EA1E
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:11:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q6so4003237eji.13
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 06:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=44rAwtd104zTF6dbWV55JEwGL2BlYGz1AUagrivcDtc=;
        b=piKrs1fQPx5PzIuxBtvL8WJ+ocepEXzMVOvQ+r6cSg5qEzEerxBPDNCRzEFSpmHsSd
         H/7xc3RxTA72PAXq+GCknvZV+fMuWqC7x/2zMuJYHWRFzUrNfUfJQj6QRyAGBRgSJPMU
         y1RTLYyMHy1BsEU/SqfTGz0vUcT4mnUhvBOcnhUN7+Rp9ZtTmRb2foY70s71EDNnizvO
         jr97BogCpA6Ba5P2VFa3WcJjHFkK1y4UrlbIpmKlKXdfZqpWFlK0cmjfVfhL2tOkDPW3
         Zi8nXg2aPPMmJ8rqlh5eUhhVVv2WciZFnH73jNHTHyPpURR00aUSAQGk4T2XEA2hR/a9
         I9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=44rAwtd104zTF6dbWV55JEwGL2BlYGz1AUagrivcDtc=;
        b=KB/Ah9Cwra26IYU7faP9ABv4QHzacE6HVrexixpUB2IfDIkRF3WMraHTqnRCxw7Uw4
         KHtWDi1q2LotERnvzBk+PccXcv4aZ3AEPO11/h+3APBHNE8/eYfyEjcI+cnc+1Ol3W46
         CdxDVDJa1GGq7UXDme8V5mKZ4ONE3qp2jtj2YEqcTNfecXSDqA9HCtxEot5gOJk8BYDb
         0RznhUu3v1+saePOzVhr+rw45wo0FEa60OBaJfXBhnZYKIYh3KQu1PiEH4EYCJ/iYqUu
         wARRjfJ5oogFLscj4o5ScjIaPgFh5hAxxGu6RsK2kz37DFohL/YS+ZnO1VUvGEcVRKnq
         Z53w==
X-Gm-Message-State: AJIora+iJSEqYLaT6+Q1W7JvgDEAyIRbPGF0gSl/N+/UZ8A+1ML5/Cn5
        gxk9QPjlvee+UDKZBD+qpQqw8CiIgBCuUw==
X-Google-Smtp-Source: AGRyM1s8IYJ+YI+ZlWvmtnpwUn/+h1WW0BjzOTyTurp9rd8PjvArrkWRTFjF180z3zStfWcrby+HCw==
X-Received: by 2002:a17:906:5053:b0:70d:a0cc:b3fd with SMTP id e19-20020a170906505300b0070da0ccb3fdmr8007855ejk.162.1655989917478;
        Thu, 23 Jun 2022 06:11:57 -0700 (PDT)
Received: from google.com (64.227.90.34.bc.googleusercontent.com. [34.90.227.64])
        by smtp.gmail.com with ESMTPSA id bx25-20020a170906a1d900b006fe8d8c54a7sm10873956ejb.87.2022.06.23.06.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 06:11:57 -0700 (PDT)
Date:   Thu, 23 Jun 2022 13:11:54 +0000
From:   Quentin Perret <qperret@google.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH 1/3] KVM: arm64: add a hypercall for disowning pages
Message-ID: <YrRmmrY24Pv6hyAO@google.com>
References: <20220623021926.3443240-1-pcc@google.com>
 <20220623021926.3443240-2-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623021926.3443240-2-pcc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On Wednesday 22 Jun 2022 at 19:19:24 (-0700), Peter Collingbourne wrote:
> @@ -677,9 +678,9 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
>  	/*
>  	 * The refcount tracks valid entries as well as invalid entries if they
>  	 * encode ownership of a page to another entity than the page-table
> -	 * owner, whose id is 0.
> +	 * owner, whose id is 0, or NOBODY, which does not correspond to a page-table.
>  	 */
> -	return !!pte;
> +	return !!pte && pte != kvm_init_invalid_leaf_owner(PKVM_ID_NOBODY);
>  }

I'm not sure to understand this part? By not refcounting the PTEs that
are annotated with PKVM_ID_NOBODY, the page-table page that contains
them may be freed at some point. And when that happens, I don't see how
the hypervisor will remember to block host accesses to the disowned
pages.

Cheers,
Quentin
