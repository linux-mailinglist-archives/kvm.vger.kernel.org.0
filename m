Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EE51713CF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 10:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgB0JMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 04:12:07 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39905 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgB0JMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 04:12:06 -0500
Received: by mail-lf1-f66.google.com with SMTP id n30so1508423lfh.6
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 01:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R2lIUx+nuCng7WT5OBlXhdq9LBq1TmJJFlRXaUTRA8Y=;
        b=NPUW0v2heoUFp9zL/k4LKptrBstq8o67ceZ32apKGs1AYmB87dzmEZG2HY+pivTRdO
         Z4n+UTGPe3jxAEs19A2zwzsbghObVIFrupxcEVbuD7Cg4QarlG0y3/KArDq4KfSCeaxi
         KMEn8SPEsjTKOFFJQTQU6wR5zsA8dp+8AiYaN8ZamyuUQlJxLIryVoFaSSfiPJkmmdYn
         2+8xU0Hflt/+wsasb7F9bSu/17F/INQfZBviSY4kxHJh9M9uP4TMN6Fg3vK05KF0eBP/
         +jfIs5ef2ev1VDnxnQG8G0VGpHqC7NJAUMBVMBmhs8BJewVMVAfOydHGqv0Ltr/ZU6tp
         P5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R2lIUx+nuCng7WT5OBlXhdq9LBq1TmJJFlRXaUTRA8Y=;
        b=miuR8/ZVgGHkUb4HVHH3NbAQVNAB38Le9Sr+KJXkZ5tVay4qukiDzOHw82tcdBhZ9H
         c55fpECCDTMvFgPsS+OjCHnZPYZ5VPy/82IgYIeyB6JPa0bqIcJJvTv1s3h6qZzDP42g
         hKB3VPwQF5rBRgD0kwxdMpG7LY823vY/z+hey6jzP9IcUK0M+eEluX7i/nKcG/Yonjbj
         LS/Mfl/5wk7eXKdgwYelVmQsDwCgB19o9t1TnvDFb7k4LK/8oO3379c6gH6X7wjjjy/c
         S8PpfiOVpQ+3T1B3c5cpphbOPRHAxaIIwdp07RshmD8M0+qRP5du2iinxeRwf3ZGFaoO
         389g==
X-Gm-Message-State: ANhLgQ3b5kMM7kJ1HkIknZQSnCa8bFMojajL+OYaDt13zfUpJEICqGOw
        UKSj/cgqBS1hoy63JlZnjz6sbG4Xli74rFqBs8ZGamjT
X-Google-Smtp-Source: ADFU+vvteeecMfZgOxab6UBZtLxxHe9G73CiOuHuI60I/5KbA5+l8DPWGErhtgCuv/uEV4rN1LApR7ce5b7tykqONDY=
X-Received: by 2002:a19:550d:: with SMTP id n13mr1671390lfe.110.1582794724791;
 Thu, 27 Feb 2020 01:12:04 -0800 (PST)
MIME-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com> <045fcfb5-8578-ad22-7c3e-6bbf20c4ea35@redhat.com>
 <CAOQ_Qsg6DnSGU26xBJAQ6CGb6Lh5jX7VTvoXFZRnx3_f0eKYGQ@mail.gmail.com> <74650413-5cbc-6dd7-498e-22e89f1f6732@redhat.com>
In-Reply-To: <74650413-5cbc-6dd7-498e-22e89f1f6732@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Thu, 27 Feb 2020 01:11:53 -0800
Message-ID: <CAOQ_QsgbDUNxKgqEnQUs_sHShrRREpqwJ_=Cg9bjdo9-sBBH9A@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Handle monitor trap flag during instruction emulation
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 10:38 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 27/02/20 01:22, Oliver Upton wrote:
> > Are there any strong opinions about how the newly introduced nested
> > state should be handled across live migrations? When applying this
> > patch set internally I realized live migration would be busted in the
> > case of a kernel rollback (i.e. a kernel with this patchset emits the
> > nested state, kernel w/o receives it + refuses).
>
> Only if you use MTF + emulation.  In this case it's a pure bugfix so
> it's okay to break backwards migration.  If it's really a new feature,
> it should support KVM_ENABLE_CAP to enable it.
>
> Paolo
>

True. I suppose I've conflated the pure bugfix here with the fact that
MTF is new to us.

Thanks Paolo!

--
Best,
Oliver

> > Easy fix is to only turn on the feature once it is rollback-proof, but
> > I wonder if there is any room for improvement on this topic..
>
