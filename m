Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422D34B2AD9
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 17:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351707AbiBKQpd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 11:45:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351697AbiBKQpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 11:45:32 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BE0D67
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:45:31 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id q11-20020a17090a304b00b001b94d25eaecso4847186pjl.4
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 08:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dFXJ174/FHjksMgNtUqWugIkgOl10ic8u3Hye+5cX+c=;
        b=YM/qktxwg58lxRejUqZuM+1MRPwM2m6VurqVzGgAbO1zxTIYMgnrhnBS9beXDliQsT
         kpLM29GY0tvK1TzYqkcG5vnZtGcU2eTdVR3xdVhLMNL2g/Z11yxZdJv8qm9bx8s2HUoW
         0yq2Ru37y0tDHpukzg7fJEAEF4sn92Uedeo4Xlu5PHLN/DENgNAWLy4o2eCm5jSEo3r4
         ikqOw0QoSKLttaXbeUuGfs4L7BynQ6CXkgXNGDngpBZqv16B2VPKocCNOubZlZBEn9jS
         2EuYpOpoIhw4fOR1kbDt/J/zwD8cOO2Puobt0Ew2nRNSlCEPg5eBYyi8fwxnq6slpJYO
         Yd9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dFXJ174/FHjksMgNtUqWugIkgOl10ic8u3Hye+5cX+c=;
        b=grP+SbX7NqkN5EPjQjn2VIsJSrkVySQrfQW6EZvH44fO4NmaR0i3pC/KEhU2Kc1Gp3
         1f9SBDGA45ICX+H4JsUpNrRjX/uio1BYQTmb1FrFjtPg9DHRUUHKqn8ICFkfCqRsok0w
         SofdUxuy/m4y/dtOt6mfkNZicwFbU2Uaj5iO23B4o7T4b8PapTdKwiUbPOIVbvCIZkEb
         /bfxQ8EexREy1D3gXCYFmsbJ5s0epT2YfptFWQt2SkRGwXDMM/pjmkhhz/CnnicD9Et2
         DLrxTQ5rAE63xdpjZt4e3MO/Xi1l0kE1jTLW494qCif7EWn4J50rPIPGInJV4T5muD1P
         GlVg==
X-Gm-Message-State: AOAM5302P+FJDvmsk6h/BdndQ/OdaOuiKJJc69wu0wLlKirCbs+n4LEN
        1gdNnFwsLJ8dL1KowtZH67QBMgMxSmaybw==
X-Google-Smtp-Source: ABdhPJzrzruCL6VeeZwq5YsFvJWqAM8TXVJ3XRvp97kLJM99sybRe+Gw+FFx8J8h7fW5UNTBuQyn+A==
X-Received: by 2002:a17:90a:4a09:: with SMTP id e9mr1289939pjh.36.1644597930604;
        Fri, 11 Feb 2022 08:45:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x1sm28587057pfh.167.2022.02.11.08.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 08:45:29 -0800 (PST)
Date:   Fri, 11 Feb 2022 16:45:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
Subject: Re: [PATCH 2/3] KVM: SVM: set IRR in svm_deliver_interrupt
Message-ID: <YgaSpuhhJsQKLvfP@google.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
 <20220211110117.2764381-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211110117.2764381-3-pbonzini@redhat.com>
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

On Fri, Feb 11, 2022, Paolo Bonzini wrote:
> SVM has to set IRR for both the AVIC and the software-LAPIC case,
> so pull it up to the common function that handles both configurations.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
