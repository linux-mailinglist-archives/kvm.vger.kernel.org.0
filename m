Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4561F7AD9C5
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjIYOLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 10:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjIYOLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 10:11:51 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3976E107
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 07:11:44 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-50300cb4776so10641017e87.3
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 07:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695651102; x=1696255902; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBOvC0K9KP7qMsTGJs/XlB/BY83dr7+2ydlkGk5mVEI=;
        b=A1ReN1v/MyjTJISpXYZWQ0/P03lWqOwjc+hhpHnHuj1o0MUac2KzSwQPdKUj2EfW6w
         gKZeSHTk47h6yo4YCkIk7KZc9b+jSdf8wLKFIaMuvgP/vMR+/PKtGi0t7+Yh366X+ahs
         NCHlUYF6CqmwiWkUiYU9hXkkovqC4O2ocupYorzUmmkQcFScZxgPY857dfo+8rRP/jsG
         D4k67Ke/fRtNtZ0VrMImhpcuZWr18cSl/tmZomXEakdEJsWIwVu14UZOl8BI1zcD2g28
         1xWdE0Gers5nImse9ZBC0BZvefwRpE4ID1VNWMIB0Tx+847Mw35mina4xPBVg5Ae/+Sv
         zSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695651102; x=1696255902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lBOvC0K9KP7qMsTGJs/XlB/BY83dr7+2ydlkGk5mVEI=;
        b=qEknq3SJOQRFpfbd8u5bSoKc/e+Ecb5C4b/EQJop4f7mpmEcEkyUHN7Ym/3srag6wU
         4NM2NA5Dh4TXZ2NjT2qnVIiMtKDpq2jV/96rIO5/qvf3bWXIYXHfmViXa7neN4jSa1Gg
         gicKWBd9gJBAi4cpUwsarWKjPAwHm7DZPoq9s3HEjkrwSLwQGNMpvqVzlDJcYyPIS5yw
         CLHMP8/ktP+5aNfyI5K3BSZL1vrOF5N5OqLRGV/gPLi5i53NHY4VbU4nFvynssBTbPnY
         z5Hk9kwAZ4ESobYPQDHRIA30HD9dow/Qh5bKt8+jA/qwx6C71k0Q6PFQ1KEnKe4Aavw6
         qbgQ==
X-Gm-Message-State: AOJu0YyvnZocdL3hLsOkndi1Sx8hRjFhC1F49q2BDEjhDjqBdBddXKjV
        el5/ynxORO+9aCDGpEiZVpaW2A==
X-Google-Smtp-Source: AGHT+IH/enSkU0B+xx17RFHSrcUfQKwrTeyF3VIzAeMXRjn8t4tSgmAPSe37mpYZRA3+eXRrZXDAYg==
X-Received: by 2002:a05:6512:2089:b0:500:9d6c:913e with SMTP id t9-20020a056512208900b005009d6c913emr4888703lfr.52.1695651102197;
        Mon, 25 Sep 2023 07:11:42 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id x13-20020aa7d38d000000b0052fe12a864esm5562105edq.57.2023.09.25.07.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 07:11:41 -0700 (PDT)
Date:   Mon, 25 Sep 2023 16:11:39 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Conor Dooley <conor@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        devicetree@vger.kernel.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/9] dt-bindings: riscv: Add XVentanaCondOps extension
 entry
Message-ID: <20230925-e2aee59a5ea91fa14fab12ed@orel>
References: <20230925133859.1735879-1-apatel@ventanamicro.com>
 <20230925133859.1735879-2-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925133859.1735879-2-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25, 2023 at 07:08:51PM +0530, Anup Patel wrote:
> Add an entry for the XVentanaCondOps extension to the
> riscv,isa-extensions property.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  Documentation/devicetree/bindings/riscv/extensions.yaml | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
> index 36ff6749fbba..cad8ef68eca7 100644
> --- a/Documentation/devicetree/bindings/riscv/extensions.yaml
> +++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
> @@ -171,6 +171,13 @@ properties:
>              memory types as ratified in the 20191213 version of the privileged
>              ISA specification.
>  
> +        - const: xventanacondops
> +          description: |
> +            The Ventana specific XVentanaCondOps extension for conditional
> +            arithmetic and conditional-select/move operations defined by the
> +            Ventana custom extensions specification v1.0.1 (or higher) at
> +            https://github.com/ventanamicro/ventana-custom-extensions/releases.
> +
>          - const: zba
>            description: |
>              The standard Zba bit-manipulation extension for address generation
> -- 
> 2.34.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
