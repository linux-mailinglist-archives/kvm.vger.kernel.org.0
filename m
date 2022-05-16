Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEE152929E
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349291AbiEPVMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349694AbiEPVLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:11:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9693C12ACD
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:58:33 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i8so1664423plr.13
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 13:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZBW5f9oNJuWH7Pl2cXxscrmibJPAHN6AmSJQMK5Jit8=;
        b=KxhFeNW3NvvojTiw/RbAmyXO79f4GzKGFKyKZrWOnH81/3ots14Ppt6qyDxqaW6rps
         Eg2Uhe79ig5ierEOr6PamgwA3X9ppGxJs4/dbxFwVfHTOltDkdODSJ5jaFTncu1hHR15
         8vvK/K60zQ3zT8U7KZK68EZ8ftfvki5CP42MCy1y6uczqI0YHQVSA4QkADr4ughycF6q
         g+O/tAkpxwviDmK4kYrL/gfIhB30m8Pj6WZ3QC7v5FutAOemz6XuGQFUVHCGI+oEtZMY
         Q2LmkYsPFwkkkaK/Bvpe72pR5ZQ9cYyXA8iOUehIzYF2O54N+gNQSZMOSxTP5VHBcybS
         2vlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZBW5f9oNJuWH7Pl2cXxscrmibJPAHN6AmSJQMK5Jit8=;
        b=Gq7repCvjoRjUF0scNZOczxOmkUOxQNGI8+GCRrSTQzWp5mfq1zOh7OFZ3mWEiUwb8
         inI15Q17hSU1Y+V/eht9RFqSL8RHG131bX6cmUAwWRqCcntwY/R19wdvRC/7Nnw2HWGh
         lB5HiV9j3OyhH1zF/wgOZVqlOyAoWWBIBVVCmQf/BxU0E1O8SyST2+QNy7kvDVbjqihw
         0w0+HYx484WsJc+0qjYWD4J4VgZ2QSuS7qj8nEh/lBobEJoXv7D3CHHAL7UA25DRzgz3
         KJdDXwymckpWmX7hVSETxOCHDSTdTZLyJuyv0Xzw76vDO9D6IBpD9fehze/Ff3wzqYrx
         vPBA==
X-Gm-Message-State: AOAM533GBy3Vh+r/m/cR7Udnmh1Ileqq3ip1rQshtRyUId4+AGJ4h8nQ
        BcOhR3xYej+Yrzlk7vrjKkdX6A==
X-Google-Smtp-Source: ABdhPJxRQwGCNO0hflWvXv7RtPZp3F4Rxnm+jrmINmmFGcQx90QTYHXzd4Izu1KEOamoad5n5xd8LQ==
X-Received: by 2002:a17:90b:3901:b0:1dc:5a24:691 with SMTP id ob1-20020a17090b390100b001dc5a240691mr32815900pjb.40.1652734712911;
        Mon, 16 May 2022 13:58:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ja1-20020a170902efc100b001617e18e253sm2538839plb.143.2022.05.16.13.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 13:58:32 -0700 (PDT)
Date:   Mon, 16 May 2022 20:58:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: Shove vm stats_id init into
 kvm_create_vm_debugfs()
Message-ID: <YoK69aQ6kVmzdrVu@google.com>
References: <20220415201542.1496582-1-oupton@google.com>
 <20220415201542.1496582-2-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415201542.1496582-2-oupton@google.com>
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

On Fri, Apr 15, 2022, Oliver Upton wrote:
> The field is only ever used for debugfs; put the initialization where
> it belongs.

No?

static ssize_t kvm_vm_stats_read(struct file *file, char __user *user_buffer,
			      size_t size, loff_t *offset)
{
	struct kvm *kvm = file->private_data;

	return kvm_stats_read(kvm->stats_id, &kvm_vm_stats_header,
				&kvm_vm_stats_desc[0], &kvm->stat,
				sizeof(kvm->stat), user_buffer, size, offset);
}

static const struct file_operations kvm_vm_stats_fops = {
	.read = kvm_vm_stats_read,
	.llseek = noop_llseek,
};


And with a name like kvm->stats_id, debugfs seems like it's piggbacking stats,
not the other way 'round.
