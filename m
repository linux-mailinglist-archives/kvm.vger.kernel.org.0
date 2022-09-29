Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7625EF88D
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 17:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235882AbiI2PVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 11:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbiI2PVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 11:21:39 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E2E8B2CA
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:21:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b23so1724337pfp.9
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=+DNNP6SHxbQnNh6YvMOmq3FXeAXvMFe/ESayAoZ8RAc=;
        b=QfjHyNuy9ubDPnO1F1EywSQRa43BRlBD1elemgCKhFUx95gJTgftGmM7zenvcr+vP2
         NNPXYODaUrG6ZcL5ShCQGniRniwQ9Q0dgfD8Yc18qmR8S43eQn45iL5YamTQepz4Oe+z
         5AvilvLcNkYHY1lg5izYSjO9yrnYsPRZhSJhgZBl30ETXDtv8N3ul4SM1BtZ/MZdqAj6
         vgdHNj6co8pMsjnpJbwi6LZl2A9XlBzg3xkLAF1oXD4Z5UyzOMz8jEblFDXNT0MfpgQh
         3iSAeaYikiItVFN4amJ5xmljriRfxGOWNZS7c4U/DHQGX7S/X0JQ9rZEqVZAoIuMVLHO
         YUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=+DNNP6SHxbQnNh6YvMOmq3FXeAXvMFe/ESayAoZ8RAc=;
        b=4IErPKJmMLnJs7Qen0KK00A9BtmJOkioCDbDHS+HDEz7LgGDNAeE0EAUseeTr+x6f6
         VT8S1WyJYc8H6zEnjbwOzr69irPn3zMbKAGCW0UA4LYBL33oRbVyjTVMmzkvsXnDOs5T
         kWIO3CpGye+1FZV4/ZNbgvyIL6KL6qbtzW4iP9bSBW0LyNdQWI44yi6iSpGPJ8ffqFmP
         1lfEbI5wtTJ+6AHAHF4RPGUYt7Qb+KEZYcDojGMotS7IOK1hbVvvKlfU5pUCckdcLtf9
         73vCsm8yaqxS4ZjEXjYkC947Wz9e8smAhp8Udhd+TctNWtQPKprIlM15aCdw0a8vEgmx
         g67w==
X-Gm-Message-State: ACrzQf0r7840X+/mYy8NvZKU4ZpKVN3DKj3fuoSpG85CTh6x1BAtj5oD
        +5xlVtQ7pXehhXtDygCrcATkbg==
X-Google-Smtp-Source: AMsMyM7H917Sg+MttAyxwzaKo5iPEQjGqRIX6khDOT3zeXNheBMvFb18YVSJGNVn/GVF8iOJdQWNHw==
X-Received: by 2002:a65:4508:0:b0:43c:e3c6:d1c2 with SMTP id n8-20020a654508000000b0043ce3c6d1c2mr3341488pgq.582.1664464895083;
        Thu, 29 Sep 2022 08:21:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j3-20020a170902758300b001750b31faabsm5967160pll.262.2022.09.29.08.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 08:21:34 -0700 (PDT)
Date:   Thu, 29 Sep 2022 15:21:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 1/7] KVM: selftests: Implement memcmp(), memcpy(), and
 memset() for guest use
Message-ID: <YzW3+0yIkMwi4YdT@google.com>
References: <20220928233652.783504-1-seanjc@google.com>
 <20220928233652.783504-2-seanjc@google.com>
 <20220929084855.26t6r6aaurm2caum@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929084855.26t6r6aaurm2caum@kamzik>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 29, 2022, Andrew Jones wrote:
> On Wed, Sep 28, 2022 at 11:36:46PM +0000, Sean Christopherson wrote:
> > @@ -232,6 +235,12 @@ $(LIBKVM_C_OBJ): $(OUTPUT)/%.o: %.c
> >  $(LIBKVM_S_OBJ): $(OUTPUT)/%.o: %.S
> >  	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >  
> > +# Compile the string overrides as freestanding to prevent the compiler from
> > +# generating self-referential code, e.g. with "freestanding" the compiler may
>                                             ^ without

Oof, good eyes.  Thanks!
