Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C686106DC
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 02:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235252AbiJ1Abd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 20:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbiJ1Abc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 20:31:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FB67A522
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:31:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso3107012pjc.2
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 17:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IuaazBA4+tuocqtu1Fkv5f0PH2eBHuEAovkINOjohoY=;
        b=DfA7zjsWWw1SoI1x9xbvWl7l52LbGyRRZ2PDLf+qLUuvsq0cBsgtI6AjJLWb8V3mtS
         97whlfyy653IZ+L7s5JJVb659IxGoED5S+Q7FvU7im/Ij2JUXirL4MlaNO87qhGvPTeG
         819uLuxsjBJ200wY0Dic1CyAXsu2QCvQkss3DuHSPjW17iiPx1G4vlCQ+fPB4hePqk4A
         d++2WZjPJQY1uLtwHdmUTFwpn52Q5QRthRtC9eQoP2hEjYiu9CCeR+4mWBrg3mI0dUfq
         F5k4GAw2YenmwwgmSEx7BQTEA+8tYZvLFaKdSCumbefNbeU5nfJofA+NUOSRAwj2hh+y
         YoBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuaazBA4+tuocqtu1Fkv5f0PH2eBHuEAovkINOjohoY=;
        b=jWb68h6QimyLt3tcPjK+KgU59roGBuf+8GQGVIwjtZhLm60DVRofl6UmC/RFMuAJ8c
         bkLk2QqGePGXuNEtHiSUnBolhA0k5TPvzsD5rl0mBHeDzPAC5+Lr9DJ7nN/gQqBdjEq3
         OP/6UYWx0wr9JxZ4bax+k23Yk5WtsLNbgYdLqRe1UUEYgzsk0lPrsLILRv56+cQx5pDv
         7DoXAtyJqFOuOdE94aE0vkvTyE4qoJg3MXx9cw8lMFoAaD7sRcC+JNGtZxpaRUDYXrwv
         Stp8zkZ0idlYNl646JMuz7m/6c07nw1oMbJ1IN/v4V6EVt+t0jAe+z+EIFCmfBqxTeZ6
         fjlQ==
X-Gm-Message-State: ACrzQf1wAA0fNrgurTg5J0QMyfnQFGF5C7T45iYRIbwAmkFsgoqNzRcx
        CBA0uuoSyxRD30gx7KReftNL2ogp98Gn/w==
X-Google-Smtp-Source: AMsMyM5ncwGWjV1rnizHLTOCp/6aO5VRl2eVdP3bFhoArl0VWjVJrFa8QRDEFYq4tRwcpVk3z1abUw==
X-Received: by 2002:a17:902:edcd:b0:17a:6fa:228d with SMTP id q13-20020a170902edcd00b0017a06fa228dmr51993090plk.29.1666917090677;
        Thu, 27 Oct 2022 17:31:30 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ecc900b00186f1a1fb6csm1173714plh.175.2022.10.27.17.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 17:31:30 -0700 (PDT)
Date:   Fri, 28 Oct 2022 00:31:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/8] KVM: selftests: Expect #PF(RSVD) when TDP is
 disabled
Message-ID: <Y1si3zrLnC0IIwG1@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018214612.3445074-8-dmatlack@google.com>
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

On Tue, Oct 18, 2022, David Matlack wrote:
> @@ -50,6 +73,9 @@ int main(int argc, char *argv[])
>  	TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
>  
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +	vm_install_exception_handler(vm, PF_VECTOR, guest_page_fault_handler);

Instead of installing an exception handler,

	u8 vector = kvm_asm_safe(KVM_ASM_SAFE(FLDS_MEM_EAX),
				 "a"(MEM_REGION_GVA));

then the guest/test can provide more precise information if a #PF doesn't occur.
