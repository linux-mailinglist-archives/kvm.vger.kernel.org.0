Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BD0EF0AF
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 23:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729687AbfKDWlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 17:41:23 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45195 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbfKDWlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 17:41:23 -0500
Received: by mail-io1-f68.google.com with SMTP id s17so20361217iol.12
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 14:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EQ3bDoVY6e0kGa1FgLWv0gYdM8AeWLhXEQCq1fkzFHI=;
        b=ZHjUwWAJO2j6pOwt5SzwwkSZIuSRDIcRHnJtOsc0uMsTjlYsVtrPMkMo2W1HVABzEm
         f9lZIAK/1q8aCjtN8S8phaIcGmsM/wztDYZb5lEF803J06SEr+aXIaqfwNpRMsPZbfPy
         +FcPC6vSglY2s/UOQoqmq5sJsyKVSqJxCc8hDY3Eria3p8hf6qk0RawJ22guegp+tnHV
         nS9G77ymOtHKJBzZr5H1RTjxRYDAE7r5gDnONlTK4fczokpwDWqG5bqGwFYr3Rf+l4e+
         htmfZuIPAFvVUesNOeOU7aLLKWJoKVVusGrBpDlbfEMBzFwv5D3++jdUehe8fGmgAfU3
         y1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EQ3bDoVY6e0kGa1FgLWv0gYdM8AeWLhXEQCq1fkzFHI=;
        b=a1dt08L0FDME0Damt/xqVx2gZIZr9h/f5AVFGY3WQSmsOhdw0iDdIYoA3C+jKhxdkJ
         Z9CrcE+pZAlP5sT0bj9A/wNFdarK6LgHgALM6VFW0ZLsZTbs0I9DIOzmSxQr1fA8B5NU
         oX3wpX/zjZp2MbB+gyP0QNBGjuMKei7wSJgGufgZLdkqNielTq8af7fO4dtoeHGUcG51
         ycrW+1NZs64Gfzwbd/eV9pL18las0sRgKG7HQzxxSD5lDOy8wIDDVFGAuVjwaNODOTaN
         TXNTmBRloYRLgmnn59eBYlIFMyQmlRptzM4VAI6A8QKKD0XyIfSyzyetCNzg1Wz9Bo3p
         M/GQ==
X-Gm-Message-State: APjAAAUyfFyNad2FJp5ADkNLUaqYdPknNU+PEsXzMrxo2vdhe+Wmgsne
        1zA4tLTf9YcvFt2f7r2a0bRE3rDV+O2ytGWyRV4twQ==
X-Google-Smtp-Source: APXvYqyhKZCkt8OXgd8+tzcQvxwDj8dFThUYYjRlEOQjjd059zEmAbWyf0WjBaI/Lp48CUPEIWdQJUcICUxwoyt+/Is=
X-Received: by 2002:a5d:888d:: with SMTP id d13mr4079840ioo.119.1572907281680;
 Mon, 04 Nov 2019 14:41:21 -0800 (PST)
MIME-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com> <20191029210555.138393-2-aaronlewis@google.com>
In-Reply-To: <20191029210555.138393-2-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Nov 2019 14:41:10 -0800
Message-ID: <CALMp9eQJGyPAnBiQF=fgLLDh4Jq8MF5N0dZ1wy+Run-nC8oeSw@mail.gmail.com>
Subject: Re: [PATCH 1/4] kvm: nested: Introduce read_and_check_msr_entry()
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 2:06 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add the function read_and_check_msr_entry() which just pulls some code
> out of nested_vmx_store_msr() for now, however, this is in preparation
> for a change later in this series were we reuse the code in
> read_and_check_msr_entry().
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: Iaf8787198c06674e8b0555982a962f5bd288e43f
Drop the Change-Id.

Reviewed-by: Jim Mattson <jmattson@google.com>
