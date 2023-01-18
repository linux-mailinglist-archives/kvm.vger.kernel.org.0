Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291D16729B8
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 21:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjARUvD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 15:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjARUup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 15:50:45 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA49613CD
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 12:50:32 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id jl3so277755plb.8
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 12:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=svbi23Bf7G7TpszzbredrX9t138yDUamrj0MjFsKqDs=;
        b=Ja60k0uaY2y+uAHoC0XCVBogwu6cVGziixF8yj0njcBAiPvwPdFN3k5pw0dTXv5/Gx
         LwVStbFNYvToriLeeH8kDuNTmVXteTYQd9vHcXFd00EDkYXnL0Aefll/2WHMBVJWBMjk
         9SAXq+mxW00DrKkDX6YCKCsdWkZx8Cd2XfKIufUL1gbKr6jmS42KH9BpEAxxRPaSyvLI
         h7uNQ+TfMOV1hLRZMfPD0mvsSpUlp86fDDpJOjuHhvlXoA9BZzZjumkEKwj6y72oXTI/
         iuhj12Hq26EDMMc+95uU8XAXkQ3yI8+luWIzFyc1+tFVCELblF7sAKMvhmB3hZ8LWO9Q
         GEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svbi23Bf7G7TpszzbredrX9t138yDUamrj0MjFsKqDs=;
        b=XXgd7DR2x4G+LlSenjNIV46WrI5F9V4iCPbzTqggqEMFdmu48TrwX8fzhHFVL6CQ2g
         QI7l0nSK6GkkbRFSWSoxI2rbIioIueQ5+m5/W98LcdGL7ZlM1M8ZqZfbiP/BNrPmwyzk
         F3ZTjOFemF5esXnxUOc6dADO5M20u6s2XXebY3H8F9Q5m6cUGrQUK6jUMtkzl04m3vz6
         o0iJQYos8manVgYJoTc5b+I+7rQf1xznjFNKVtDz/awKgNn/s6cXJXGKuamEJIuIneic
         5kg+AiJsnqUB5OvBN5+E7SM+uA29xd1h/rcdduy3AoGUCGhJd8heN1an5oNAm7aGZ7/1
         SDrQ==
X-Gm-Message-State: AFqh2koONKO1kPUT6JMGUwEH5L5hDYb+rYIVdFGQXjiEMHRiWfXPLQIU
        yZFo6j11WSYYV/hrKNdSj1+Amg==
X-Google-Smtp-Source: AMrXdXtqGP0OSfyW0P1XNGdZx+AwtHEJl+79Y/0uccPkfRehsMuaJs1SnhYkPOwnKyhbkV3+IeHYpA==
X-Received: by 2002:a17:902:e808:b0:189:b910:c6d2 with SMTP id u8-20020a170902e80800b00189b910c6d2mr3510690plg.1.1674075032263;
        Wed, 18 Jan 2023 12:50:32 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c16-20020a170902d49000b00194afa2d4e5sm3236389plg.62.2023.01.18.12.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 12:50:31 -0800 (PST)
Date:   Wed, 18 Jan 2023 20:50:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, pbonzini@redhat.com, andrew.jones@linux.dev,
        vannapurve@google.com, Ackerley Tng <ackerleytng@google.com>
Subject: Re: [PATCH V6 0/7] KVM: selftests: Add simple SEV test
Message-ID: <Y8hblFklBZSS+tS/@google.com>
References: <20230110175057.715453-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110175057.715453-1-pgonda@google.com>
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

On Tue, Jan 10, 2023, Peter Gonda wrote:
> This patch series continues the work Michael Roth has done in supporting
> SEV guests in selftests. It continues on top of the work Sean
> Christopherson has sent to support ucalls from SEV guests. Along with a
> very simple version of the SEV selftests Michael originally proposed.

I got two copies of this series.  AFAICT, the only difference is that LKML is
Cc'd on the second send.  When resending an _identical_ series, e.g. because you
forgot to Cc' someone or because mails got lost in transit, add RESEND in between
the square braces in the subject of all patches so as not to confuse folks that
get both (or multiple) copies.
