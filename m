Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2947276ACD7
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 11:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjHAJXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 05:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbjHAJXW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 05:23:22 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92E130EC
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 02:22:10 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-99bc0a20b54so860556366b.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 02:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690881728; x=1691486528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Myyg/9EMvFaXxS0MQuf9oic0JS5pwyGRhUlLiVOQ7cg=;
        b=DGWQ06MMOa/673UDiUbHWfvDEjjljcO9pgXIH6f6q3vLvc/6vEnY+ydAuN/HHflZw7
         AEtTWAMYn2GMKYtLMtMn0sNzJhSMyTGc72izAJnHuEBYp/kviEPOsfYW3tBXsZLz1PSf
         nBrWKS8QWxWdlC0S2oc2b2Naf7e+9rX/TpPlLu7KyDtKBI9F9Zrx84HkFyoZTBPXk8MP
         Jvt8JbrfF2AGM7+dLEe7fEc5iLz5MqPpWIp8f/uPfCunfiL1nnGJHq3jtELhLSbKLAGm
         mh24x/4jIeOLx+JlPwlkhpN6AUwtg2z4cOQAKda5EfZUA7TbLlBc8zPbXNEKZ6KENpoz
         nQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690881728; x=1691486528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Myyg/9EMvFaXxS0MQuf9oic0JS5pwyGRhUlLiVOQ7cg=;
        b=JDQG8Wke8AdbIKqbkkfSJkmx6X299fyF6hJFmC97PncseN/9RCszpQZSDEy/ip4GJR
         RFPoEJYbyG9PQBmlG4ru4GMDj8jy8uJQGy1j4gRAQqO6aWk5nZ4rS9dZnEjdW4LQjTd0
         42XlsmLD/XGZ12rGWFlStOuBV3upZ9R5PpZdFmleUeBqnlJIS/2j/TVmeV710sLsnkXc
         MQ0cKGSyvFHcpxKTr3JWWyTFU1/f0IthvZK9YnHoMvnToOISe2vTEne/oR6YbLsQPqYI
         pJU0Sj04NdmL5DKFzYPoJAUDYAffbOrl08duY9VsCdjOtbpQjp9x8slfoPHz6hdvWGVA
         er+w==
X-Gm-Message-State: ABy/qLa+Ef6PBk2aInz2l5luzpVoYBsKdHcidF55ZKFFLiCLjQbsRY8t
        frHAzz7Qg0f7aVJFcBegpaUleA==
X-Google-Smtp-Source: APBJJlGm6uA+LAnVlBtxIfLwMvjWRv2Gwia6HLAVmhzKy7IakWIq/kLqxEYhBEJoOBpXfLEql9cNOA==
X-Received: by 2002:a17:906:768d:b0:993:e691:6dd5 with SMTP id o13-20020a170906768d00b00993e6916dd5mr1914773ejm.7.1690881728816;
        Tue, 01 Aug 2023 02:22:08 -0700 (PDT)
Received: from localhost (212-5-140-29.ip.btc-net.bg. [212.5.140.29])
        by smtp.gmail.com with ESMTPSA id x20-20020a1709065ad400b00988be3c1d87sm7375676ejs.116.2023.08.01.02.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 02:22:08 -0700 (PDT)
Date:   Tue, 1 Aug 2023 11:22:07 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH v4.1 2/3] KVM: selftests: Add #define of expected KVM
 exit reason for ucall
Message-ID: <20230801-121c649de93d2bcd54af14c4@orel>
References: <20230731203026.1192091-1-seanjc@google.com>
 <20230731203026.1192091-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230731203026.1192091-3-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 31, 2023 at 01:30:25PM -0700, Sean Christopherson wrote:
> Define the expected architecture specific exit reason for a successful
> ucall so that common tests can assert that a ucall occurred without the
> test needing to implement arch specific code.
> 
> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  tools/testing/selftests/kvm/include/aarch64/ucall.h | 2 ++
>  tools/testing/selftests/kvm/include/riscv/ucall.h   | 2 ++
>  tools/testing/selftests/kvm/include/s390x/ucall.h   | 2 ++
>  tools/testing/selftests/kvm/include/x86_64/ucall.h  | 2 ++
>  4 files changed, 8 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
