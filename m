Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F7B281ABA
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 20:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387768AbgJBSS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 14:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBSS5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 14:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601662735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IH8F866OWsGPhTpURhBie5+G2Wdh5o25NFqTjcx6COE=;
        b=Op2An5xJOinu3TilFoq0wxvPeTqwGZJvc9RINYI+jUE3vVLitw5VfVwCjxwK7pmpdMsNko
        ebLYPjYeL8yTTpjsTtobVwBxCGOYXt6a6fRVMBJplH77QwcW/LGhRFD7SbriHKK9cMFZyR
        /H3ez1V9SYxZ1lqthI5bPFXqCcsk8dA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-5t7wkShYPVWUqOk0yvaTZw-1; Fri, 02 Oct 2020 14:18:53 -0400
X-MC-Unique: 5t7wkShYPVWUqOk0yvaTZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B82D7802B4C;
        Fri,  2 Oct 2020 18:18:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF55610013D7;
        Fri,  2 Oct 2020 18:18:47 +0000 (UTC)
Date:   Fri, 2 Oct 2020 20:18:44 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 1/7] lib/list: Add double linked list
 management functions
Message-ID: <20201002181844.jknzoeyigdew26ek@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-2-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002154420.292134-2-imbrenda@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 05:44:14PM +0200, Claudio Imbrenda wrote:
> Add simple double linked lists.
> 
> Apart from the struct itself, there are functions to add and remove
> items, and check for emptyness.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/list.h | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 lib/list.h
> 
> diff --git a/lib/list.h b/lib/list.h
> new file mode 100644
> index 0000000..702a78c
> --- /dev/null
> +++ b/lib/list.h
> @@ -0,0 +1,53 @@
> +#ifndef LIST_H
> +#define LIST_H
> +
> +#include <stdbool.h>
> +
> +/*
> + * Simple double linked list. The pointer to the list is a list item itself,
> + * like in the kernel implementation.
> + */
> +struct linked_list {
> +	struct linked_list *prev;
> +	struct linked_list *next;
> +};
> +
> +/*
> + * An empty list is a list item whose prev and next both point to itself.
> + * Returns true if the list is empty.
> + */
> +static inline bool is_list_empty(struct linked_list *p)

I'd prefer the 'is' to be dropped or to come after 'list' in the name.
Or, why not just use all the same names as the kernel, including call
the structure list_head?

> +{
> +	return !p->next || !p->prev || p == p->next || p == p->prev;

The '||'s can't be right and I'm not sure what you want to do about the
NULLs. I think forbidding them is probably best, meaning this function
should be

 {
  assert(p && p->prev && p->next);
  return p->prev == p && p->next == p;
 }

But since p can't be NULL, then we should always return true from this
function anyway, as a list with a single entry ('p') isn't empty.
The kernel's list_empty() call explicitly calls its parameter 'head',
because it expects a list's head pointer, which is a pointer to a
list_head that is not embedded in a structure.

> +}
> +
> +/*
> + * Remove the given element from the list, if the list is not already empty.
> + * The removed element is returned.
> + */
> +static inline struct linked_list *list_remove(struct linked_list *l)
> +{
> +	if (is_list_empty(l))
> +		return NULL;

This isn't necessary. Removing an entry from a list of one entry is still
the entry.

> +
> +	l->prev->next = l->next;
> +	l->next->prev = l->prev;
> +	l->prev = l->next = NULL;
> +
> +	return l;
> +}
> +
> +/*
> + * Add the given element after the given list head.
> + */
> +static inline void list_add(struct linked_list *head, struct linked_list *li)
> +{
> +	assert(li);
> +	assert(head);
> +	li->prev = head;
> +	li->next = head->next;
> +	head->next->prev = li;
> +	head->next = li;
> +}
> +
> +#endif
> -- 
> 2.26.2
>

I think we should just copy the kernel's list_head much closer.

Thanks,
drew 

