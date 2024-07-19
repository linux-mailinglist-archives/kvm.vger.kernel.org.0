Return-Path: <kvm+bounces-21960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA6D937C6A
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 20:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5466B281370
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 682D11474B6;
	Fri, 19 Jul 2024 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jId69Uuv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F115C43687;
	Fri, 19 Jul 2024 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721413333; cv=none; b=cssRbCqc5Yh1/V8dlV2aTSF64SoxbanBx5T/TrsS1m/cD+Aaw0Do3e5puiSrqCFfDzAX5IKqPiXLwAhDqBqd/gkVlgeNVdXUEIYatOLPt9Z1w8bUYBL4IM873HVoq5XAdN70Y8lRVJ58FlrpebYJfmNnhr6w/RlnLvbN1svSPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721413333; c=relaxed/simple;
	bh=kVbtgwmOaHxsovn5R9rvfRJlZmldZDhlk3RFiGxYCFA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=KRd9arqZ78OGIVM3G9Qcl+VPtjtkVqUzB5nuJ6l1dcm0i/IlxZmZVuefH7+scfWCrf/YfE91LUxpNd5BUq3AeJuFDOOuDkCJ8ATkLDSGV4SbOTV7vVirhCqSBb+hCCOGnDzKIzzmgZAIEOl2nGn0bhmZlilMqc8No4ckysg8B1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jId69Uuv; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-367940c57ddso787323f8f.3;
        Fri, 19 Jul 2024 11:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721413330; x=1722018130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fphJdhSwBnMGf7p3TzYU+xwrvqtrmXWS07sYNKmmszg=;
        b=jId69UuvUpwEVmzfSK4uck/GlA5PAJB0JmMy3npBxX90PFCmhFlS/VC9B3rc0Zkg4M
         eOwloinSdBMb2SQ4AslPNsDGWzvwpJTU9ieUFzxANPTwbKvmzo2fPGLMuiMb6FQv8n4h
         TnEMMglaOr2SyYTyGvgMy0QKFSUaSSYc3w92iwcdgRYwaYbueh3q5+8cvqjn2fQKNFMR
         YZagiCODhrNs6O/AxEermYQltbbTR6J1Rj/qw/Oaa2iiLIBl22n3nMaSdhemKe9jBjDz
         fBNmfe7zdGKIsdys1rVr6hI6x/Rm3Bp3G79EDLBbMq0jUkMz9vx89s+Jg4VUDLYgIkNU
         TImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721413330; x=1722018130;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fphJdhSwBnMGf7p3TzYU+xwrvqtrmXWS07sYNKmmszg=;
        b=Q6NpYMIGmYZ3huoAbZ9EtJruOf9yqaHC1DAy1wsA/9L/m+Fvsjc+whfA7KHa9xm9Nm
         Taz77wKjrFP4+ERP0wk/GthpbtHOvTrEwOpIT8THgo0qGoLLkySKc5txBC0HaQMB2CJA
         WjuOKby1YpyIjTNP3Qulocw1/iTdwMAg5QC5F2NTa9IX67DDARixUbAQ3vuiOLo6DmEr
         qH7+0oNJYnv/ZjlNj/oFd2q0MLRu/ZPMKBudTvmCBAyoSwMlNwwL97i2NSXq786aS5/u
         HYSJubYts/z2r+F4XW8VwsU+VwlvBOds++dgTJIuA8kARvjWWzKl9vOCVrsrDrHSPl36
         WS1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU+u2F6zySqDJyn5Cbxrb5YY7apRXQYtTR3oJ0uWJXIjIb/PQDSMH3P1pS5JPhPT4R5g43iWwTwyRNs7lzsV/6D70e7olTCVOq0wQzs
X-Gm-Message-State: AOJu0Yw3xYimMZI1/Du8lmUGsvPyUXh3Gd4KmcUCqJ1LAroTtbi6BA+q
	45IUHmOyU27y1ofvU/Cmuhdkdr7qRa9t/fk+p/5c9fWYexhYptyo9fXQKKUG
X-Google-Smtp-Source: AGHT+IGMfDj75GDbUxb77AkkoADTxGyAnUjqg9Od86gvhtnV5E/USszOXlgUmdkTZi5zrpjvFj39jA==
X-Received: by 2002:adf:b64e:0:b0:367:8fc3:a25b with SMTP id ffacd0b85a97d-3683171e405mr4879969f8f.42.1721413329765;
        Fri, 19 Jul 2024 11:22:09 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d692998csm33208945e9.32.2024.07.19.11.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 11:22:09 -0700 (PDT)
Message-ID: <1eb96f85-edee-45fc-930f-a192cecbf54c@gmail.com>
Date: Fri, 19 Jul 2024 20:22:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_arch/x86/kvm/x86=2Ec=3A_In_function_=E2=80=98pr?=
 =?UTF-8?Q?epare=5Femulation=5Ffailure=5Fexit=E2=80=99=3A_error=3A_use_of_NU?=
 =?UTF-8?Q?LL_=E2=80=98data=E2=80=99_where_non-null_expected?=
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 David Edmondson <david.edmondson@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, all!

On linux-stable 6.10 vanilla tree, another NULL pointer is passed, which was detected
by the fortify-string.h mechanism.

arch/x86/kvm/x86.c
==================

13667 kvm_prepare_emulation_failure_exit(vcpu);

calls

8796 __kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);

which calls

8790 prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);

Note here that data == NULL and ndata = 0.

again data == NULL and ndata == 0, which passes unchanged all until

8773 memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data, ndata * sizeof(data[0]));

The problem code was introduced with the commit e615e355894e6.

arch/x86/kvm/x86.c
==================
  8728 static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
  8729                                            u8 ndata, u8 *insn_bytes, u8 insn_size)
  8730 {
  8731         struct kvm_run *run = vcpu->run;
  8732         u64 info[5];
  8733         u8 info_start;
  8734 
  8735         /*
  8736          * Zero the whole array used to retrieve the exit info, as casting to
  8737          * u32 for select entries will leave some chunks uninitialized.
  8738          */
  8739         memset(&info, 0, sizeof(info));
  8740 
  8741         static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
  8742                                            &info[2], (u32 *)&info[3],
  8743                                            (u32 *)&info[4]);
  8744         
  8745         run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
  8746         run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
  8747 
  8748         /*
  8749          * There's currently space for 13 entries, but 5 are used for the exit
  8750          * reason and info.  Restrict to 4 to reduce the maintenance burden
  8751          * when expanding kvm_run.emulation_failure in the future.
  8752          */
  8753         if (WARN_ON_ONCE(ndata > 4))
  8754                 ndata = 4;
  8755 
  8756         /* Always include the flags as a 'data' entry. */
  8757         info_start = 1;
  8758         run->emulation_failure.flags = 0;
  8759         
  8760         if (insn_size) {
  8761                 BUILD_BUG_ON((sizeof(run->emulation_failure.insn_size) +
  8762                               sizeof(run->emulation_failure.insn_bytes) != 16));
  8763                 info_start += 2;
  8764                 run->emulation_failure.flags |=
  8765                         KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
  8766                 run->emulation_failure.insn_size = insn_size;
  8767                 memset(run->emulation_failure.insn_bytes, 0x90,
  8768                        sizeof(run->emulation_failure.insn_bytes));
  8769                 memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
  8770         }
  8771         
  8772         memcpy(&run->internal.data[info_start], info, sizeof(info));
  8773         memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
  8774                ndata * sizeof(data[0]));   
  8775  
  8776         run->emulation_failure.ndata = info_start + ARRAY_SIZE(info) + ndata;
  8777 }               
  8778 
  8779 static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
  8780 {
  8781         struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
  8782                 
  8783         prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
  8784                                        ctxt->fetch.end - ctxt->fetch.data);
  8785 }
  8786                 
  8787 void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
  8788                                           u8 ndata)
  8789 {
  8790         prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
  8791 }
  8792 EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
  8793 
  8794 void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
  8795 {
  8796         __kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
  8797 }

Probably before memcpy() with ndata == 0 ended in a NOOP, but now CONFIG_FORTIFY_SOURCE=y
turns a warning, or prevents the build with -Werror.

Hope this helps.

Best regards,
Mirsad Todorovac

