Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3634668882F
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 21:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbjBBUWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 15:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjBBUWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 15:22:53 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8849F4390D
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 12:22:52 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id k13-20020a92c24d000000b003127853ef5dso1965503ilo.5
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 12:22:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8NI8G3MUYPvndKeLhb40B6Enk6uRYjAAMWKfkextf2M=;
        b=UaBYKtKt7rp3wgxND80ZXGrnXhekOH2cnt3JdZ77hj5WIocLRssJdyDD4Eu60caONX
         2SwG8AGmDsrN8H4JkHy0dw6he5oTxqshx2PPiUc7MV/3wPminTlmgQ8A5/t4NoEAI6J4
         O6ESjZGIUgAkxADlqOHmO/dPxJSznbG+YfoAtNPAfTlrfw709h71p2IFbOdTFgjKAy8E
         8dHTLii+y9Ynl7R7pEaBbkvEm1CfUpWEGr4wqES8umdZ6Boa95nrDF9Cyvp98p0XGuN7
         Yg093nEpOqEOj43d9PanB/webQYB3pHsEIG1G0v6hCRxeqJnNSrmFSigO7eT4XT+ozxb
         8xQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8NI8G3MUYPvndKeLhb40B6Enk6uRYjAAMWKfkextf2M=;
        b=04YvgZaY9BLhNURbm4ZYF5PLFzPVbWzYXyRZkvGSo0iNqVv6NLgRoe4xQVXL39se63
         pnxqmow93sT3kLwtfoECD/U2Co7b4LMAWgPGtAJMNi/wmhMri9PfONc6sdZSkjmpoAcc
         gFkF/y1IMUL00EnHcsXzziyR/XSrKENbu/fkImbg8D4WarXlwUGoEhw/IU4i4vw6sjqC
         CvI+y4EMxJimnW+M+UFyN9sQprkdEI9S75cQKaoxrJ5IhPj2b1ZL08PPNhn1wBS1sHjx
         xAJp/slyYu761CGTBvncE/Uf92ClXw8eEApeiTIOWamstPCDAOQDATxpLc86pXZWG7jc
         qGTw==
X-Gm-Message-State: AO0yUKU/SJOiMM5WugXj2Bc+xB2RPqxkCLDrdTveqbZoJBoNa0+Q7Y0O
        T9kp36rFwhKM6yRpsTAKr5ln6YVsFfNPGA7n9w==
X-Google-Smtp-Source: AK7set/4mwqzZMqy6bglBKnpA4nqxRTU1S7BEtMfTbq8gbWNzmgAHZ0e8NkIoN3dklrEn2IzikHViI5fcUDIDtN4fQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6602:492:b0:715:fdfd:318a with
 SMTP id y18-20020a056602049200b00715fdfd318amr1822920iov.78.1675369371775;
 Thu, 02 Feb 2023 12:22:51 -0800 (PST)
Date:   Thu, 02 Feb 2023 20:22:50 +0000
In-Reply-To: <20230202080122.2kbtmsbcu45pzr4f@orel> (message from Andrew Jones
 on Thu, 2 Feb 2023 09:01:22 +0100)
Mime-Version: 1.0
Message-ID: <gsnt4js3yfz9.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [kvm-unit-tests PATCH v4 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
From:   Colton Lewis <coltonlewis@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     thuth@redhat.com, pbonzini@redhat.com, nrb@linux.ibm.com,
        imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andrew Jones <andrew.jones@linux.dev> writes:

>> +# error first. The awk program takes the last number from the QEMU

> I point this awk reference out in the last review. I also stated
> we should do something else, which is not done in this version.
> Go read the last review comments again.


I apologize for not reading your last review more closely and checking
my work. I read your word "comment" but thought you were only referring
to the commit message since that's where you placed the text.

As for the something else, you mentioned wrapping the code in an $ARCH
check but stated that should be another patch. I did not catch the
followup where you suggested doing it now.

I will do that next version.
