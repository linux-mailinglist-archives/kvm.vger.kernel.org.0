Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59D21C78A6
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgEFRuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 13:50:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39572 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728834AbgEFRuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 13:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588787421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Z05vQkXn+ziuAvD6utXhI68kib5oxgxkY6iHW+5GBI=;
        b=YNOxCKmebSpgCzyHqCKWxrc8VPYay+kfARw0JIil54sTV6f1fm13BvPzX8U940Umx0AJ9O
        Vg8rw7pz/NnsPiKGN/nlVNYlFyELnvfnjQgJwRP1aeGVhPILoci1nrbqDKH49L70T0HKRu
        G3Xhr4lPtqptGJFv1jyHBfxTlDf1HHg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-k_EEip9XMp-1HzVIQ4rgug-1; Wed, 06 May 2020 13:50:16 -0400
X-MC-Unique: k_EEip9XMp-1HzVIQ4rgug-1
Received: by mail-qt1-f197.google.com with SMTP id g8so3736280qtq.2
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 10:50:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7Z05vQkXn+ziuAvD6utXhI68kib5oxgxkY6iHW+5GBI=;
        b=krwuZhXu7jdcRMEDGLPYhFjkEjyGc+HJvB7pYuHvDc5I0oHuIJHheYTi+Opgmf78q1
         5RI51xs5SnxBZRPY2bIxnqj2V1mit8xONU61IFqcdQ7lJ7cUSeSyKmXbja+VG9rJcOyU
         0zGuU/U6DJ0uboZCCLbqr5wkCcJQuya1+PfWEDhF8il8UctRm30LWD3xvgJdmzZ2DSSU
         r7wGhRKftPeIrh61VQwbUgGxQdjZ2nhAUixcGALKI4gEBjRlzDlsIMT4KjFyap8yta0O
         2Z1Ei/+TPsqLr3Y84jicyDLofdRzXPS5twApFnnkVVSNJdG83b3tBGOKEbU7FeQin/br
         8O+Q==
X-Gm-Message-State: AGi0PuYur1L8LBlpfEhYXAN88iqCZp9k+ME8NaLlS1qLiuMVHDaz5yRM
        AMNUwO3D8D6o5bqBDtmxosxnXj4SUCQTgv/SPeyCtiuD6cBL9BUm+j/iiBiq0RQuD0U3WNz2Twt
        iKBHuHtZnbkyx
X-Received: by 2002:ad4:5449:: with SMTP id h9mr9475639qvt.108.1588787415485;
        Wed, 06 May 2020 10:50:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypLqVrwGhKkJV64MsIWU5/JpO0dfx6jsJGkVCuI8nRpNJiKMXo0786rKvdn7EkGwPa5Czka7LQ==
X-Received: by 2002:ad4:5449:: with SMTP id h9mr9475615qvt.108.1588787415250;
        Wed, 06 May 2020 10:50:15 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id 124sm2289941qkn.73.2020.05.06.10.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 10:50:14 -0700 (PDT)
Date:   Wed, 6 May 2020 13:50:13 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 9/9] KVM: VMX: pass correct DR6 for GD userspace exit
Message-ID: <20200506175013.GP6299@xz-x1>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-10-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200506111034.11756-10-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 07:10:34AM -0400, Paolo Bonzini wrote:
> When KVM_EXIT_DEBUG is raised for the disabled-breakpoints case (DR7.GD),
> DR6 was incorrectly copied from the value in the VM.  Instead,
> DR6.BD should be set in order to catch this case.
> 
> On AMD this does not need any special code because the processor triggers
> a #DB exception that is intercepted.  However, the testcase would fail
> without the previous patch because both DR6.BS and DR6.BD would be set.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

