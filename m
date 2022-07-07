Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5F456AC9D
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 22:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiGGUSS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 16:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbiGGUSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 16:18:16 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE4723BD9
        for <kvm@vger.kernel.org>; Thu,  7 Jul 2022 13:18:14 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y141so21594451pfb.7
        for <kvm@vger.kernel.org>; Thu, 07 Jul 2022 13:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1bCm969XGgaOkqh4eRSQbwrpF0kvcOdbQDiSoaqggZA=;
        b=Zak8jiTq85bczrwETGrZMCWPGn3uIDl2243XVn3Cka9H68zrC7vNFRcZEOnmJgrTFd
         Wr9mmzUXkp8oLEloQextca673lYKEvA61aY2CVXnh+R2i9sjKJVCFmba9HEKjzAdNBUP
         NjsfCc0sUnPhxERGS1i6EE8p0QBXetVyScGxOj8ijgpAdFc30gTP9YFlgyYYsD2BPfKF
         uYQSAHfzZsQyLqEzKeHUwmmTqWPr76vRn2dymaBXj8HAJzHklWGuYrC5qplBQhHEl+aW
         PVMz2DUB8v49XBYahpDbUCE1BVEi9qTxI2kavjktAeIzZBo3vtgONMGS8Fs8nrYFe2L/
         oqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1bCm969XGgaOkqh4eRSQbwrpF0kvcOdbQDiSoaqggZA=;
        b=hv1WBSCaGds4Kt15GhGW+WSSJNutRMOiw/tnpmu/Hb2oukmdxz4tYt8l8s0uy+zbli
         OSxIOF+nOZmd+4NfQfDpnJb3ySxPmUXQiVbk0fGv7N7bNKQ7Zb+u9WV1k0IdVWg0diWV
         TzZdgVz/7gA68bT5am6SJnZ3K2lNfERGlj+DGEuYpuiR9eQpIpMRYB59xOcuTH18I5TA
         nWge/bv7Dbsjnsy72I7xv2GOAdXam5KCEseQyOHvLUBD/aFSs60DOUxavX5xOEwXxRRk
         xH5OlCOV8J2N1zYlsVs8lhA71ZNnYC8x7aZHubCM9Ja1ZBZJxVGZynaGaJYEZnCcCZoy
         OiYQ==
X-Gm-Message-State: AJIora9ul1Bblrq9ASUqn2l9ezwvz7QZ3qXlbBGIaLeAHiuJuhe7IVGk
        vIiS/GH+5IEbi3GEVaI0uaxkiw==
X-Google-Smtp-Source: AGRyM1u7Vnw+L1f3h+y+anT6YpnUnamRUClSCjg14JDJMI45LSX0ApzgomkSHh6BXqdmDdTFpVMlIA==
X-Received: by 2002:a17:90a:2c0d:b0:1ef:c839:c34b with SMTP id m13-20020a17090a2c0d00b001efc839c34bmr7189286pjd.39.1657225094391;
        Thu, 07 Jul 2022 13:18:14 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id o188-20020a625ac5000000b0052a198c2046sm229368pfb.203.2022.07.07.13.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 13:18:13 -0700 (PDT)
Date:   Thu, 7 Jul 2022 20:18:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Replace UNMAPPED_GVA with INVALID_GPA for
 gva_to_gpa()
Message-ID: <Ysc/gaTYjJNkuq9u@google.com>
References: <6104978956449467d3c68f1ad7f2c2f6d771d0ee.1656667239.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6104978956449467d3c68f1ad7f2c2f6d771d0ee.1656667239.git.houwenlong.hwl@antgroup.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022, Hou Wenlong wrote:
> The result of gva_to_gpa() is physical address not virtual address,
> it is odd that UNMAPPED_GVA macro is used as the result for physical
> address. Replace UNMAPPED_GVA with INVALID_GPA and drop UNMAPPED_GVA
> macro.
> 
> No functional change intended.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
