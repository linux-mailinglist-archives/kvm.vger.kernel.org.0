Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7936743A6
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjASUry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjASUrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:47:48 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D784EE4
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:47:45 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id v6so8904910ejg.6
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Auj6XCXOBwJJlVzevyyph1mYwbHw+mWksSnSvNFWQIg=;
        b=oL1bfvLo7cVGrIodoE9TXFo/GXsYhB75CDKi5NHFRobQvCVDPdFvcqng76CFYfj7x7
         yESJQqZs7YS/2pFaLuWLPiRv5C68yK4jt4D7RT01k7fSjCgwoFJm1A3M2mwPc4vH2qQG
         Cgeet1dTTQrj6ajl4sWnUqbBKGUBiGhSOLFccD111UYFpk1zNdY6g0EBYzSZlLM3/vCm
         Ef89nDDn/DMCm3CcnNS8GIVqyHz6lsrwkztEHu5YxKcjpU68JQVGy5yImv+HmAdbKDtA
         6YrvLwAkHL/Y+vx0D26a4LjqMTAM4dkAq5j1R2zsBOptljdA6gobYq+lbGWtidFqDEqf
         G0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Auj6XCXOBwJJlVzevyyph1mYwbHw+mWksSnSvNFWQIg=;
        b=DD4pNtI3rC/YHbH32c8H8a6zFBmWCxIFyFQeXgbBuCqWGUIwWmDUrXtNuoMbGaPB8a
         /PP9Z3lKOZUAP453ziCMKvxwl2GRq/+M05mhEz/hdplGw1MnZ5/ImhNHUktNaRtZBxFc
         9Kz9opTUaAsRrGX7ym8Il/qviIl0FHOVaf714hzqXVnpc9VgLuLUMUSHXTXlSgjiX11V
         dtct98ssqm9NWj75XglbqdEM+VPJDi8XK4MRdfe9cSfv+nCpV4fU0pHRNxR/AlgflKcW
         LrDzS58SCbcwAjy6TJrY+zQ0zglXervQZeWw5QzBulugl9gGML9xFmea02MmeYx3lmn7
         bwjw==
X-Gm-Message-State: AFqh2kreYOOua4BimhnBreryCmkNPlG97xAISN4axIyDlYBFrT6Woj1Q
        Iw/W0Pl4qQUjppp5oAmJLQPh75/oUWATqDct8R+pTQ==
X-Google-Smtp-Source: AMrXdXvcGdPvGop4M3UQ0q7VaEQzCiFuc+nu85C71F04aC54bS0mY807Xoqo4SvoTwiC5lNh34RsC9rkQ3ubzPrZXWU=
X-Received: by 2002:a17:906:37d4:b0:854:cd76:e982 with SMTP id
 o20-20020a17090637d400b00854cd76e982mr1048141ejc.364.1674161263571; Thu, 19
 Jan 2023 12:47:43 -0800 (PST)
MIME-Version: 1.0
References: <20230119200553.3922206-1-bgardon@google.com> <Y8mqd7HUzXDnhXLV@google.com>
In-Reply-To: <Y8mqd7HUzXDnhXLV@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 19 Jan 2023 12:47:31 -0800
Message-ID: <CANgfPd902Sd+LCd61D8=ba2ZTbJCRu3emLXtE212_8NWW6c3Pw@mail.gmail.com>
Subject: Re: [RFC 1/2] selftests: KVM: Move dirty logging functions to memstress.(c|h)
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
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

Woops! I did not mean to tag this RFC. Sorry about that. I will
include a cover letter in the future and can resend these with one if
preferred.

On Thu, Jan 19, 2023 at 12:39 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Please provide cover letters for multi-patch series, regardless of how trivial
> the series is.
>
> This series especially needs a cover explaining why it's tagged "RFC".
