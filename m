Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FCE6DFF4F
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 22:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDLUAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 16:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDLUAe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 16:00:34 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A42D55
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 13:00:33 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id bv129-20020a632e87000000b00517a229708bso5553859pgb.9
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 13:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681329632; x=1683921632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jcl3gk9M3bVX56GXSurnA4vZncbccQIQ9VxkxYgM9Q=;
        b=aYTaBGWsNj/eD5+dBuK5/K4fkvMZxMAfXONBZxomMlrYfP1RL3ITgO0fmP3GosT/CK
         uoLSxD7O+CvXxrQ6eK0W6Z+EA7tMbRkhaIl/RgM2CpJP5PfiIe9F08jtdu/BRhydsO5G
         EMgggw2ctVGMVMy0OGbep32I+0lp4shm14tuzP55T79mAeC4rN9tejlSw7wsws0e8AVK
         zG3ZlK0my54GrboRYTUMZMYb5Px6zWhMlSK62B1AUmjp19sAAQrQ8DZaXSEwVaRC0gqg
         Pwr/FxPp5dwoWuYWl06ZX9elR6kWmN6/XAB0ehZn+4StXZmdXxgi/IIzaLQnC/1K+Rkc
         3dWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681329632; x=1683921632;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Jcl3gk9M3bVX56GXSurnA4vZncbccQIQ9VxkxYgM9Q=;
        b=lgS8bTJxtFI5tLhlPB51dtqg90DxN0F2Y08N/dZmS0txHQtFemZXMd8U4aLV6BZe+5
         KgE4cc92eOdGoZkHz57S7A4TGl9vZ0BVzxDe3HL13JBIcugVo/nXpJtUzLIgH+tKmkg8
         0NRuAXsG/CTNpwV4S01k8pr5vwzn807VOol+Qu9Xs6pS/b1X5J/T3w7DBF9cmqMTsuJl
         kIOGIH1wVkqbh11J6vgLwsT0qNCURhxZ5X/qZ/fSw7Xb3AVPT8a4O7HJhgAN7NJDAZhA
         zYUMkOT0YcigK292E3XoLx4pacWj6PfnrD+KGHbWmTcexD5BPpj6/QZ7mJqPvOZkrlrU
         qyyw==
X-Gm-Message-State: AAQBX9cWTvu17Jf8rKgw4PMKwu8461vsK5LG1D5X2pL/oPc/2fiCMmFc
        Gf3HmUUUPSbYnSZLITk9vflmmYOin3E=
X-Google-Smtp-Source: AKy350ZGVQ/mTN9gkBB6k/G/BtgTqq5qVlxj5ol2tx70CKiHj0o/v9nbxasL0zmBUP3/LG6bFL8ZoRTgfVI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2111:0:b0:503:a26e:b4cf with SMTP id
 h17-20020a632111000000b00503a26eb4cfmr5037260pgh.8.1681329632566; Wed, 12 Apr
 2023 13:00:32 -0700 (PDT)
Date:   Wed, 12 Apr 2023 13:00:30 -0700
In-Reply-To: <20230412194942.1556575-1-pbonzini@redhat.com>
Mime-Version: 1.0
References: <20230322011440.2195485-1-seanjc@google.com> <20230412194942.1556575-1-pbonzini@redhat.com>
Message-ID: <ZDcN3hLF+5Vn2qKr@google.com>
Subject: Re: [PATCH 0/6] KVM: x86: Unhost the *_CMD MSR mess
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023, Paolo Bonzini wrote:
> Queued, thanks.

Roger that, I'll drop kvm-x86/cmd_msrs.
