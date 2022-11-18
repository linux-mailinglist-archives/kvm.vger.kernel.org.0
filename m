Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEF062F9E1
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241741AbiKRQEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 11:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241550AbiKRQEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 11:04:20 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341DB8CFD8
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:04:20 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id h193so5337085pgc.10
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SlFVrej9bt4YEUqyZWryuI8fTcVVTeK+6ZolSLExKOo=;
        b=HvcoXdH7ttv9Bf+uw0Ns4EN0hYL9WLK3zx1ep4D98FrWoNLmOjfRcYrS8wv95bHTU0
         dUZoP3H+9NjYegMqMpD30OiZgQjjM/tWjdAbToHWmRqO5pdKdDINR4EXe2F/bS3lmbcA
         w7BxwfcPHZE6gd4PPAHBfEgcexn55aFwgnLHAnXwR0rlvie0Jlp13SX3MvdWKcLS9TF8
         U41ADoXkBU7BcUovJlp0QvwHja0S9Yhra7rn/nJCZeoXgTsr+lx4F12wYd62moC6FLX1
         KXNDigpp/8AAm2cekP7Xm8gP2KXiWH7ABMOzM38IF7dIZvHFaDbli8kWQf3QfTnJGSHJ
         rpOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlFVrej9bt4YEUqyZWryuI8fTcVVTeK+6ZolSLExKOo=;
        b=q4/o/6x9gQoDqyIAD7FLQfHGAPv6Xhn2gJw78aF0/aD2JO2lPoMV6pE2Ce1MZ8aJpc
         SKvnGtNv82Hd75T8To/a6qLb5JEN6xERjCzYrX4mQ73gpOrV2ka3N6UN6vTvcnJt0aod
         BunC8gw9CyCcflv+lbprFIyUU4OAfHRoCxIIOF1bTnqauQ7qvPgcKEfteOEQqxyjyDEq
         Al9XLKV3KcXJO1EnktHFHSIg7k4CkU6KPX9dAnQdB11PQ7V7M/B4K7E9mC6qptYUgidx
         FG7pqkLR0TNToKKdI5v4QjPQd6ZP/gYQDPhNrMomZHHbf58vOz2DUJQKLCFZHY8AVtke
         CTdw==
X-Gm-Message-State: ANoB5plEMCHgEGF468NhrjS7n7I1xTiHvKoxh7BFOe8UTjaP93WI+Z1e
        nm8kX4KKB30xX8nmRP9DA5/eXQ==
X-Google-Smtp-Source: AA0mqf4zEGFlIGLb7p38iRQ/pYcFzeVxsEZxePUGfaUEEC0R0h+cKILFDnFOOmPBIbr5+jmr+ewFcw==
X-Received: by 2002:a63:d117:0:b0:476:c781:d3ae with SMTP id k23-20020a63d117000000b00476c781d3aemr7072807pgg.183.1668787459569;
        Fri, 18 Nov 2022 08:04:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r2-20020a170902c60200b001766a3b2a26sm3820057plr.105.2022.11.18.08.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 08:04:19 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:04:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Greg Edwards <gedwards@ddn.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v3] KVM: x86: Allow APICv APIC ID inhibit to be cleared
Message-ID: <Y3es/yLTo1dXSzAF@google.com>
References: <20221114202037.254176-1-gedwards@ddn.com>
 <20221117183247.94314-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117183247.94314-1-gedwards@ddn.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022, Greg Edwards wrote:
> Legacy kernels prior to commit 4399c03c6780 ("x86/apic: Remove
> verify_local_APIC()") write the APIC ID of the boot CPU twice to verify
> a functioning local APIC.  This results in APIC acceleration inhibited
> on these kernels for reason APICV_INHIBIT_REASON_APIC_ID_MODIFIED.
> 
> Allow the APICV_INHIBIT_REASON_APIC_ID_MODIFIED inhibit reason to be
> cleared if/when all APICs in xAPIC mode set their APIC ID back to the
> expected vcpu_id value.
> 
> Fold the functionality previously in kvm_lapic_xapic_id_updated() into
> kvm_recalculate_apic_map(), as this allows examining all APICs in one
> pass.
> 
> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
> Signed-off-by: Greg Edwards <gedwards@ddn.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
