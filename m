Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1900D5BD57E
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 22:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiISUBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 16:01:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISUBW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 16:01:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546274A105
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 13:01:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x1so235913plv.5
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date;
        bh=d2mOaXqBJ/J1NiBq+p9zZqqA3x7aa90eBHG5Ll0Tfso=;
        b=fdaJHOO3a2pIOR/89fIgJSQloU9jbVrOA5QbPQYMMYhLs8KoKEqyaQOH63NzdC0BW5
         +xcbWp6DgPQyD8KWK1F+0hqGEOAMaJii6EDQQ+46c4Vd6yCQMokwDddgQ8ZRmNmB2qCs
         ulnhQ8DScLVB8wgMjAj1Ot2sozJegDbvU71kckRVcEkytQ86MIyC0t93pWLCWTc0/+FT
         Fr2cnmgIKc5F13hwz8ScnRXqeavbLJ/pD7MdUlOTgYtEbfeVqq21kIsvObKkjYsZcA/h
         kAWquL8pPjpQSqAdLOxChyzTrLQxPuxT1NG9TyizytbwW9o8YN5N9fj5PtmjQ/KPwAiL
         dwTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=d2mOaXqBJ/J1NiBq+p9zZqqA3x7aa90eBHG5Ll0Tfso=;
        b=rhTi1pBU+ofWs/6yG/SY7KfoOWNu6O0ziIUxp1bXt4Vuum2POZdfScahqgwsKXTG0y
         /PRyb2s60+gBxDYiIGc8WzpnT8CqdYvhYVcEAjXFIywnWjKqohro5Qc8XSGrTMSLkBSQ
         jVrGVMgF9UJ3h6EbyW7nhPmrEBN7neUBAaovTD3bxfg7KClrrf8FbL8SEKc9sNVD1TVf
         4tpVJejF0dLP+X/1/hTpBhe1vac0014oZ9XQYJ+v3L46hGGW3gvTnZGw7RsleKUbeAdE
         pDks1NSLLYEol6I0CAffQkfz0BRWsQphPD7msebY9rcduuUH/2kTtQ2GtU3ShUTT3kUk
         04YQ==
X-Gm-Message-State: ACrzQf2nRlvabRuiD3VbAgCNHatFkyOQNIm6V17V0v5OP8SrP5flTF6S
        ejTn6STVkyU6fg2VeV+Lsu64kA==
X-Google-Smtp-Source: AMsMyM7ekM/QpjauHVnjWvyDT4Y/ZpvdxNLs+apfRnU6iIqW4hyA8I00zbHqV8xMsYofHJnxlgrT4Q==
X-Received: by 2002:a17:902:cec9:b0:178:1da5:1075 with SMTP id d9-20020a170902cec900b001781da51075mr1403934plg.136.1663617678958;
        Mon, 19 Sep 2022 13:01:18 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w1-20020a1709026f0100b00178650510f9sm10750215plk.160.2022.09.19.13.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 13:01:18 -0700 (PDT)
Date:   Mon, 19 Sep 2022 20:01:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com, rananta@google.com,
        bgardon@google.com, dmatlack@google.com, axelrasmussen@google.com
Subject: Re: [PATCH v6 09/13] KVM: selftests: aarch64: Add
 aarch64/page_fault_test
Message-ID: <YyjKir3OGCfFvAsy@google.com>
References: <20220906180930.230218-1-ricarkol@google.com>
 <20220906180930.230218-10-ricarkol@google.com>
 <YyZDBIQsux1g97zl@google.com>
 <YyjDCWCJ5j8c6T2h@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YyjDCWCJ5j8c6T2h@google.com>
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

On Mon, Sep 19, 2022, Ricardo Koller wrote:
> On Sat, Sep 17, 2022 at 09:58:28PM +0000, Oliver Upton wrote:
> > @@ -536,13 +536,7 @@ static void load_exec_code_for_test(struct kvm_vm *vm)
> >  	assert(TEST_EXEC_GVA - TEST_GVA);
> >  	code = hva + 8;
> >  
> > -	/*
> > -	 * We need the cast to be separate in order for the compiler to not
> > -	 * complain with: "‘memcpy’ forming offset [1, 7] is out of the bounds
> > -	 * [0, 1] of object ‘__exec_test’ with type ‘unsigned char’"
> > -	 */
> > -	c = (uint64_t *)&__exec_test;
> > -	memcpy(code, c, 8);
> > +	*code = __exec_test;
> 
> I remember trying many ways of getting the compiler to not complain, I
> must have tried this (wonder what happened). Anyway, gcc and clang are
> happy with it.

Alternatively, from a code documentation perspective it would be nice to capture
that the size isn't arbitrary.  E.g.

  typedef uint32_t aarch64_insn_t;

  extern aarch64_insn_t __exec_test[2];

  {
	void *code;

	memcpy(code, __exec_test, sizeof(__exec_test));
  }

Note, memcpy() is currently dangerous, but hopefully that will be remedied soonish[*]

[*] https://lore.kernel.org/all/20220908233134.3523339-1-seanjc@google.com
