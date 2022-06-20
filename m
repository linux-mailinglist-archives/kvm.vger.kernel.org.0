Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECBE55118C
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 09:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239291AbiFTHeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiFTHeG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 03:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28660DED6
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 00:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655710442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9O0CIqeEaoJn03vVtSYdv9IsNbaraVCXGcehJj6LilQ=;
        b=ewkgVstQyW9Cfr3tbIeQA+8+IZLhP3s8fSfkwQipnK2ZzwqFUYtvTmiVAIhXBq2OKTvbCV
        K6QjRenFUTmtB3RZtAUPGJiUSiwxPpCVeofgJ+ry7/jNrIxL+g5bbUZgSPr4djTOKhETKK
        E8Xw7xv120qkrE///+1RI6QjSybDiMw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-H4_bUBPWOpSv-DJii70zXg-1; Mon, 20 Jun 2022 03:34:00 -0400
X-MC-Unique: H4_bUBPWOpSv-DJii70zXg-1
Received: by mail-wr1-f71.google.com with SMTP id n7-20020adfc607000000b0021a37d8f93aso2179307wrg.21
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 00:34:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9O0CIqeEaoJn03vVtSYdv9IsNbaraVCXGcehJj6LilQ=;
        b=DxbGBxxLXuoyqmou+hch63U4kNoGdm3HXxVbNYspNr2oMMqJfGOEGNRqU6FzPOK6ja
         z7vm3GG2MPivIwOkOg1hU3My61jERroUZRzTUGQ9hY9COvxlg7aJucvyRS5EXClSf2s2
         H2uTB1BasCajAvunOgadpFeXR3ZyhrlvFBNYvTTUWOHYbPraBYyYa3qgrIWaaoyGOJSt
         A4Q7/2b3/l3NdA2SfyeQIKtHCq+skzGa5pfPsJjpyTWV1B28Ga432BbHNMrAijUo30n/
         PVTtkXEpPmpGlV25saIveKDFszv2fQk64WK7O8B2W/RVdmKdeNuHg7EvinuZJkBCcamj
         z1dw==
X-Gm-Message-State: AJIora9/kAjADGyKVPc9+8rRO6A3riYGnPVXxJ9Zem5BWTWcKYxq005Y
        ZFNu7V3bu11ZxpF8C9dL4E2qPfRWu0BIwY1hU98ZHoyFYLHrRx68CDzYSPRcG+8HJoPuHX9RrgM
        BfZLR+/PbkPQ7
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id p12-20020a5d59ac000000b002185b7e1c1cmr21891417wrr.621.1655710439273;
        Mon, 20 Jun 2022 00:33:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vkewhJzwIOJ9l+/yqE7pUpzblIRdbrwtFQigT8P4KR1GnlkLPaHlZsigHVgHZi02aADaZXLg==
X-Received: by 2002:a5d:59ac:0:b0:218:5b7e:1c1c with SMTP id p12-20020a5d59ac000000b002185b7e1c1cmr21891397wrr.621.1655710439119;
        Mon, 20 Jun 2022 00:33:59 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id l9-20020a1c7909000000b0039c96b97359sm14054471wme.37.2022.06.20.00.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 00:33:58 -0700 (PDT)
Date:   Mon, 20 Jun 2022 09:33:56 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH 0/3] KVM: selftests: Consolidate ucall code
Message-ID: <20220620073356.fmtsa4ub74igm7me@gator>
References: <20220618001618.1840806-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220618001618.1840806-1-seanjc@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 18, 2022 at 12:16:15AM +0000, Sean Christopherson wrote:
> Consolidate the code for making and getting ucalls.  All architectures pass
> the ucall struct via memory, so filling and copying the struct is 100%
> generic.  The only per-arch code is sending and receiving the address of
> said struct.
> 
> Tested on x86 and arm, compile tested on s390 and RISC-V.

For the series

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

