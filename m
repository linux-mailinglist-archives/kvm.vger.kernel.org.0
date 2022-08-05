Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19FA58B047
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 21:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbiHETUm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Aug 2022 15:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiHETUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Aug 2022 15:20:41 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33D865563
        for <kvm@vger.kernel.org>; Fri,  5 Aug 2022 12:20:39 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id b4so3597075pji.4
        for <kvm@vger.kernel.org>; Fri, 05 Aug 2022 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=IhDLsJTpz87Cy+fNuAZT2J8Hez0P/MUUAjyAsKcVzbI=;
        b=W3PjcWGQyq9VzdGezgKF1FM0JcwC/10BlsekTmcRtMv2qRJb6WMu15fF0kdfpQ3T/o
         lIiIscQkshoX9XaEOzKof2RVf0XpS9JfcAWtR5DPJA6pvT6h43q9MayBVW84vZK+rhvp
         IL3jB2RYuVOXtwdTUiE194dqeBHer/FygeCyBVxGsNP+oJwHtOtAot3WfG4blKVS9HEd
         BigYZ+97gEP181SdTIODvgQzfugrrIBzgVcVpz9A8tsi59DJ31JakYQkzaysHANynN/a
         uq2oO8l7E0zaqocANWoXm/NibjwFhm8EQzBpBzv4LI/Hx8Pl9YvBQckEaamV/hc9i1GJ
         hU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=IhDLsJTpz87Cy+fNuAZT2J8Hez0P/MUUAjyAsKcVzbI=;
        b=QmXqSJhD7Usaq/NwWKng2gErq4FiHaJD778BfCLvIaOJLiMea9JVvj4ILCQ6NIrn0v
         fZDcViuuTAOEU1NEG5/5RbvOTAUhth+rhkIM3wryAaoULl/zN4HjoetPYV6v7Bl4eYcR
         ZZw3bI3cW+bCi/iNhteVJGlZ6442MsAUZqGOgRRxKAw4BzIzsVC6pESyVayOY+7/Q/2V
         nrtWCLam8n5CIdyZ6OJMGwmyqbHXh40hwkC349hWsL+MRVjWLSMnTUAqCoe20hrBZ7u+
         1iToSaupzMoolpiYxCgo130yz592ILxo0IuU4SbLo6h+oo+6EERFhiFtFpV+hj1t4fcu
         SOTA==
X-Gm-Message-State: ACgBeo1n4+gtXOLPYSqTKYz3i7JWP/ETwpEXB+lBtPF7xJasedkSbaLL
        qiVL8UHBi0GLqJpErIsxSAnNVw==
X-Google-Smtp-Source: AA6agR4tbY3NZ6pC933xQAX5Ly3Tkn6sKLHM406XwsMUKj+oSoI8h5UgNskw7q2W4bwl36T7bjchMw==
X-Received: by 2002:a17:90a:b30a:b0:1f4:e12b:6f61 with SMTP id d10-20020a17090ab30a00b001f4e12b6f61mr9087126pjr.153.1659727239193;
        Fri, 05 Aug 2022 12:20:39 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b76-20020a63344f000000b0040caab35e5bsm1795697pga.89.2022.08.05.12.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 12:20:38 -0700 (PDT)
Date:   Fri, 5 Aug 2022 19:20:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v3 4/6] KVM: Pass the name of the VM fd to
 kvm_create_vm_debugfs()
Message-ID: <Yu1tg3z08hb7Vqon@google.com>
References: <20220720092259.3491733-1-oliver.upton@linux.dev>
 <20220720092259.3491733-5-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720092259.3491733-5-oliver.upton@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022, Oliver Upton wrote:
> From: Oliver Upton <oupton@google.com>
> 
> At the time the VM fd is used in kvm_create_vm_debugfs(), the fd has
> been allocated but not yet installed. It is only really useful as an
> identifier in strings for the VM (such as debugfs).
> 
> Treat it exactly as such by passing the string name of the fd to
> kvm_create_vm_debugfs(), futureproofing against possible misuse of the
> VM fd.

One last whine session,

  kvm_create_vm_debugfs() to guard against attempts to consume the fd
  before it is installed.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
