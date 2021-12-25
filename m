Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1FA47F1FE
	for <lists+kvm@lfdr.de>; Sat, 25 Dec 2021 06:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhLYFKE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Dec 2021 00:10:04 -0500
Received: from regular1.263xmail.com ([211.150.70.198]:39298 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhLYFKD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Dec 2021 00:10:03 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Dec 2021 00:10:03 EST
Received: from localhost (unknown [192.168.167.70])
        by regular1.263xmail.com (Postfix) with ESMTP id 3F92A14CD;
        Sat, 25 Dec 2021 13:03:46 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from [192.168.1.10] (unknown [111.30.214.151])
        by smtp.263.net (postfix) whith ESMTP id P30236T139925202663168S1640408624201373_;
        Sat, 25 Dec 2021 13:03:44 +0800 (CST)
X-IP-DOMAINF: 1
X-RL-SENDER: chengang@emindsoft.com.cn
X-SENDER: chengang@emindsoft.com.cn
X-LOGIN-NAME: chengang@emindsoft.com.cn
X-FST-TO: linux-kernel@vger.kernel.org
X-RCPT-COUNT: 3
X-LOCAL-RCPT-COUNT: 0
X-MUTI-DOMAIN-COUNT: 0
X-SENDER-IP: 111.30.214.151
X-ATTACHMENT-NUM: 0
X-UNIQUE-TAG: <cc46c3a784750941edfa1ebf190541bf>
X-System-Flag: 0
Subject: Re: [PATCH] KVM: return the error code from
 kvm_arch_create_vm_debugfs when it fails
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211223013408.153595-1-gchen@itskywalker.com>
From:   Chen Gang <chengang@emindsoft.com.cn>
Message-ID: <85efe6de-7e54-be20-e4b8-5c4a08b70166@emindsoft.com.cn>
Date:   Sat, 25 Dec 2021 13:03:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20211223013408.153595-1-gchen@itskywalker.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello:

The original mail was not sent successfully, so I send it again with
another mailbox.

Thanks.

On 12/23/21 9:34 AM, gchen@itskywalker.com wrote:
> From: Chen Gang <gchen@itskywalker.com>
> 
> At present, kvm_arch_create_vm_debugfs is a new interface for arch, and
> it assumes return an none-zero error code, so the caller need check it
> and return it to the user mode.
> 
> Signed-off-by: Chen Gang <gchen@itskywalker.com>
> ---
>  virt/kvm/kvm_main.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d8a1a17bcb7e..b2de428bd4c7 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1015,7 +1015,7 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, int fd)
>  	ret = kvm_arch_create_vm_debugfs(kvm);
>  	if (ret) {
>  		kvm_destroy_vm_debugfs(kvm);
> -		return i;
> +		return ret;
>  	}
>  
>  	return 0;
> @@ -4727,7 +4727,7 @@ EXPORT_SYMBOL_GPL(file_is_kvm);
>  
>  static int kvm_dev_ioctl_create_vm(unsigned long type)
>  {
> -	int r;
> +	int r, ret;
>  	struct kvm *kvm;
>  	struct file *file;
>  
> @@ -4759,10 +4759,11 @@ static int kvm_dev_ioctl_create_vm(unsigned long type)
>  	 * cases it will be called by the final fput(file) and will take
>  	 * care of doing kvm_put_kvm(kvm).
>  	 */
> -	if (kvm_create_vm_debugfs(kvm, r) < 0) {
> +	ret = kvm_create_vm_debugfs(kvm, r);
> +	if (ret) {
>  		put_unused_fd(r);
>  		fput(file);
> -		return -ENOMEM;
> +		return ret;
>  	}
>  	kvm_uevent_notify_change(KVM_EVENT_CREATE_VM, kvm);
>  
> 


